class SocialController < ApplicationController
  
  skip_filter :award_points
  
  def askfriends
    if current_user.twitter_uid then
      client = Grackle::Client.new(:auth=>{
        :type=>:oauth,
        :consumer_key=>'LlSCGZ10wqQb96SSJQzw', :consumer_secret=>'nHsYOZwO0kuGMlkCsRIy80IIjYDr0cZqUzeXOOHro',
        :token=>current_user.twitter_oauth_token, :token_secret=>current_user.twitter_oauth_secret
      })
      client.statuses.update! :status=>"I #mightbuy a #{Topic.find_by_shortcode(params[:sc]).subject}. Should I? http://mightbuy.it/topics/#{params[:sc]}"
    end
    if current_user.facebook_uid then
      puts "it is: http://mightbuy.it#{url_for(Topic.find_by_shortcode(params[:sc]))}"
      me = FbGraph::User.me(current_user.facebook_oauth_token)
      action = me.og_action!(
        "mightbuy:might_buy",
        :product => "http://mightbuy.it/topics/#{params[:sc]}"
      )
      flash[:notice] = "Friends Asked"
      redirect_to "http://mightbuy.it/topics/#{params[:sc]}"
    else
      redirect_to "/users/auth/facebook"
    end
  end
  
  def tweeted
    
    url   = Rack::Utils.parse_query(URI.parse(params[:url]).fragment)["url"]
    url   = CGI.unescape(params[:url]) if url.blank?
    topic = ShareTracker.get( url ) || Topic.find_by_shortcode(params[:short_code])

    Shares::Tweet.create \
      :topic => topic,
      :user  => current_user,
      :visitor_code => visitor_code
      
    award_points
    
    @points_awarded = Points.allocators[:tweeting]
      
    respond_to do |wants|
      wants.js { render "points" }
    end

  end
  
  def recommended
    
    url   = CGI.unescape(params[:url])
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
  
end
