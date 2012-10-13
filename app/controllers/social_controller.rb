class SocialController < ApplicationController

  skip_filter :award_points
  before_filter :findTopic, :except => [:socialAuthenticationAPIFacebook]
  respond_to :html, :js

  # Accessible Methods (fold)

  def unlinkTwitterAccount
    unlink_twitter()
  end

  def unlinkFacebookAccount
    unlink_facebook()
  end

  def socialAuthenticationAPIFacebook
    authenticate_using_facebook_uid(params[:token])
  end
  
  def socialAuthenticationAPITwitter
    authenticate_using_twitter_uid(params[:token])
  end

  def askAllAPI
    post_to_facebook_feed(false)
    @topic.post_to_twitter(current_user)
  end

  def facebook
    unless current_user.hasFacebook?
      redirect_to_social_login(:facebook)
    else
      @share = post_to_facebook_feed(false)
      respond_with(@share, location: topics_path(@topic.shortcode, aff: 't'))
    end
  end

  def twitter
    unless current_user.hasTwitter?
      redirect_to_social_login(:twitter)
    else
      @share = @topic.post_to_twitter(current_user)
      respond_with(@share, location: topics_path(@topic.shortcode, atf: 't'))
    end
  end

  def askAll
    post_to_facebook_feed(false)
    @topic.post_to_twitter(current_user)
    redirect_to "/topics/#{@topic.shortcode}?aaf=t"
  end

  def post_to_facebook_feed(redirect = false)
    if current_user.hasFacebook?
      @topic.post_to_facebook(current_user)
    else
      if redirect
        redirect_to_social_login(:facebook)
      end
    end
  end

  def authenticate_using_facebook_uid(uid)
    # Define user as the user with uid (uid as param)
    user = User.find_by_facebook_uid(uid)
    # Check if user exists with uid
    if user then
      # Be sure user has a authentication token.  If they don't, generate one
      user.ensure_authentication_token!
      # render token as json
      render :text => {:token => user.authentication_token}.to_json
      # If user doesn't exist
    else
      # Create a new user
      u = User.new()
      # define attributes
      u.facebook_uid = params[:token]
      u.name = "#{params[:first_name]} #{params[:last_name]}"
      u.email = params[:email]
      u.facebook_oauth_token = params[:oauth_token]
      # Save user
      u.save()
      # Be sure user has a authentication token.  If they don't, generate one
      u.ensure_authentication_token!
      # render token as json
      render :text => {:token => u.authentication_token}.to_json
    end
  end
  
  def authenticate_using_twitter_uid(uid)
    # Define user as the user with uid (uid as param)
    user = User.find_by_twitter_uid(uid)
    # Check if user exists with uid
    if user then
      # Be sure user has a authentication token.  If they don't, generate one
      user.ensure_authentication_token!
      # render token as json
      render :text => {:token => user.authentication_token}.to_json
      # If user doesn't exist
    else
      # Create a new user
      u = User.new()
      # define attributes
      u.twitter_uid = params[:token]
      u.name = "#{params[:name]}"
      u.email = "#{params[:uid]}@twitter.com"
      u.twitter_oauth_token = params[:oauth_token]
      u.twitter_oauth_secret = params[:oauth_secret]
      # Save user
      u.save()
      # Be sure user has a authentication token.  If they don't, generate one
      u.ensure_authentication_token!
      # render token as json
      render :text => {:token => u.authentication_token}.to_json
    end
  end

  def unlink_facebook(redirect = true)
    current_user.update_attribute("facebook_uid", nil)
    if redirect == true
      redirect_to edit_profile_path
    end
  end

  # Facebook (end)

  def unlink_twitter(redirect = true)
    current_user.update_attribute("twitter_uid", nil)
    if redirect == true
      redirect_to edit_profile_path
    end
  end

  # Twitter (end)

  # Universal (fold)
  def redirect_to_social_login(network)
    if network == :twitter || network == "twitter" then
      redirect_to "/users/auth/twitter"
    elsif network == :facebook || network == "facebook" then
      redirect_to "/users/auth/facebook"
    end
  end

  def findTopic
    @topic = Topic.find_by_shortcode(params[:sc])
  end

  # Universal (end)

  # Other (fold)

  def tweeted

    url = Rack::Utils.parse_query(URI.parse(params[:url]).fragment)["url"]
    url = CGI.unescape(params[:url]) if url.blank?
    topic = ShareTracker.get(url) || Topic.find_by_shortcode(params[:short_code])

    Shares::Tweet.create \
            :topic => topic,
      :user => current_user,
      :visitor_code => visitor_code

    award_points

    @points_awarded = Points.allocators[:tweeting]

    respond_to do |wants|
      wants.js { render "points" }
    end

  end

  def recommended
    url = CGI.unescape(params[:url])
    topic = ShareTracker.get(url) || Topic.find_by_shortcode(params[:short_code])

    Shares::Recommend.create \
          :topic => topic,
      :user => current_user,
      :visitor_code => visitor_code

    award_points

    @points_awarded = Points.allocators[:recommending]

    respond_to do |wants|
      wants.js { render "points" }
    end

  end
  # Other (end)
  # Backend Methods (end)
end
