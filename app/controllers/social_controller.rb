class SocialController < ApplicationController

  skip_filter :award_points
  before_filter :findTopic
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
    post_to_open_graph(false)
    post_to_facebook_feed(false)
    post_to_twitter(false)
  end

  def facebook
    unless current_user.hasFacebook?
      redirect_to_social_login(:facebook)
    else
      post_to_open_graph(false)
      @share = post_to_facebook_feed(false)
      respond_with(@share, location: topics_path(@topic.shortcode, aff: 't'))
    end
  end

  def twitter
    unless current_user.hasTwitter?
      redirect_to_social_login(:twitter)
    else
      @share = post_to_twitter(false)
      respond_with(@share, location: topics_path(@topic.shortcode, atf: 't'))
    end
  end

  def askAll
    post_to_open_graph(false)
    post_to_facebook_feed(false)
    post_to_twitter(false)
    redirect_to "/topics/#{@topic.shortcode}?aaf=t"
  end

  # Accessible Methods (end)

  # Backend Methods (fold)
  # Facebook (fold)
  def post_to_open_graph(redirect = false)
    # Check if current_user has a Facebook account linked
    puts "has_facebook: ", current_user.hasFacebook?
    puts "has_twitter: ", current_user.hasTwitter?
    if current_user.hasFacebook? then
      puts "has Facebook"
      # Begin rescue block
      begin
        # Create FB User Object
        me = FbGraph::User.me(current_user.facebook_oauth_token)
        # Check if topic has a price
        if @topic.price then
          puts "price ok"
          # If so, pass price into Open Graph
          action = me.og_action!(
            "mightbuy:might_buy",
              :product => "https://www.mightbuy.it/topics/#{params[:sc]}",
              :price => Topic.find_by_shortcode(params[:sc]).price.to_s
          )
        else
          puts "price not ok"
          # If not, don't pass price into Open Graph
          action = me.og_action!(
            "mightbuy:might_buy",
              :product => "https://www.mightbuy.it/topics/#{params[:sc]}"
          )
        end

        @topic.shares.recommends.create!(user: current_user)
          # If a exception occurs, rescue
      rescue Exception => e
        # Rescue code here
        puts "exception occured: ", e

        nil
      end
      # If FB user doesn't exist
    else
      # Check if application should redirect (defined as param)
      if redirect == true then
        # If it should call redirect_to_social_login with the param of :facebook (redirect to facebook login)
        redirect_to_social_login(:facebook) and return
      end
    end
  end

  def post_to_facebook_feed(redirect = false)
    # Check if current_user has a Facebook account linked
    if current_user.hasFacebook? then
      # Begin rescue block
      begin
        me = FbGraph::User.me(current_user.facebook_oauth_token)
        desctext = @topic.body.blank? ? "Track stuff you mightbuy" : @topic.body
        #check for no images - which are returned from @topic.iImage with a noimage.png file
        noimage = true if @topic.iImage() == "https://www.mightbuy.it/assets/no_image.png"
        fb_response = if @topic.iImage() != "https://www.mightbuy.it/assets/no_image.png" then
          me.feed!(
            :message => "I MightBuy a #{@topic.subject}. #{@topic.displayPrice} Should I?",
              :picture => @topic.iImage(),
              :link => "https://www.mightbuy.it/topics/#{params[:sc]}?r=t",
              :name => "MightBuy",
              :description => desctext
          )
        else
          me.feed!(
            :message => "I MightBuy a #{@topic.subject}. #{@topic.displayPrice} Should I?",
              :link => "https://www.mightbuy.it/topics/#{params[:sc]}?r=t",
              :name => "MightBuy",
              :description => desctext
          )
        end

        # create a shares item
        @topic.shares.recommends.create!(user: current_user, with: fb_response.identifier)
          # Rescue from any exception
      rescue Exception => e
        puts "exception occured: ", e
      end
      # If current_user doesn't have a Facebook account linked ...
    else
      # Check if redirect is true (defined as param)
      if redirect == true then
        # Redirect to facebook login
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
      u.name = "#{params[:first_name]} #{params[:last_name]}"
      u.email = "#{auth.uid}@twitter.com"
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

  # Twitter (fold)
  def post_to_twitter(redirect = false)
    # Check if current_user has Twitter account linked
    if current_user.hasTwitter?
      # Begin rescue block
      begin
        # Create a new Grackle Client (New Twitter Client)
        client = Grackle::Client.new(:auth => {
          :type => :oauth,
          :consumer_key => 'kLGDHfctWCOTax3IY0Nwig', :consumer_secret => 'vP2xNwMj4jpntS6qN8Z37fY1qUTSk1vDgJT8b1HSs',
          :token => current_user.twitter_oauth_token, :token_secret => current_user.twitter_oauth_secret
        })
        # Post a status update
        twitter_response = client.statuses.update! :status => "I #mightbuy #{@topic.subject}. #{@topic.displayPrice} Should I? https://www.mightbuy.it/topics/#{params[:sc]}?r=t"

        @topic.shares.tweets.create!(user: current_user, with: twitter_response.id_str)
          # Rescue from any exception
      rescue Exception => e
        puts "====== ERROR ======"
        puts "Error is: ", e

        nil
      end
    else
      # Check if redirect is true (redirect defined as param)
      if redirect == true then
        # If so, redirect to Twitter login
        redirect_to_social_login(:twitter)
      end
    end
  end

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
