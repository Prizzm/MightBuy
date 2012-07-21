class SocialController < ApplicationController
  
  skip_filter :award_points
 
 def askfriends
   if current_user.facebook_uid && current_user.facebook_oauth_token
     begin
       me = FbGraph::User.me(current_user.facebook_oauth_token)
       action = me.og_action!(
              "mightbuy:might_buy",
              :product => "http://mightbuy.it/topics/#{params[:sc]}"
            )
       me.feed!(
            :message => "I MightBuy a #{Topic.find_by_shortcode(params[:sc]).subject}.  Should I?",
            :picture => Topic.find_by_shortcode(params[:sc]).image.url(:host => "http://mightbuy.it"),
            :link => "http://mightbuy.it/topics/#{params[:sc]}",
            :name => "MightBuy",
            :description => "Track stuff you mightbuy."
        )
     rescue FbGraph::Unauthorized => e
     end
     redirect_to "http://mightbuy.it/topics/#{params[:sc]}?af=t"
   end
   
   if current_user.twitter_uid && current_user.twitter_oauth_token && current_user.twitter_oauth_secret then
          begin
            client = Grackle::Client.new(:auth=>{
              :type=>:oauth,
              :consumer_key=>'kLGDHfctWCOTax3IY0Nwig', :consumer_secret=>'vP2xNwMj4jpntS6qN8Z37fY1qUTSk1vDgJT8b1HSs',
              :token=>current_user.twitter_oauth_token, :token_secret=>current_user.twitter_oauth_secret
            })
            client.statuses.update! :status=>"I #mightbuy #{Topic.find_by_shortcode(params[:sc]).subject}. Should I? http://mightbuy.it/topics/#{params[:sc]}?r=t"
          rescue Grackle::TwitterError => e
          end
   end
   
   if !current_user.facebook_uid && !current_user.twitter_uid then
     redirect_to "/users/auth/facebook"
   end
 end
  
  # def askfriends
  #    puts "facebook_oauth", current_user.facebook_oauth_token
  #    puts "facebook_secret", current_user.facebook_oauth_secret
  #    puts "twitter_oauth", current_user.twitter_oauth_token
  #    puts "twitter_secret", current_user.twitter_oauth_secret
  #    if current_user.twitter_uid then
  #      client = Grackle::Client.new(:auth=>{
  #        :type=>:oauth,
  #        :consumer_key=>'kLGDHfctWCOTax3IY0Nwig', :consumer_secret=>'vP2xNwMj4jpntS6qN8Z37fY1qUTSk1vDgJT8b1HSs',
  #        :token=>current_user.twitter_oauth_token, :token_secret=>current_user.twitter_oauth_secret
  #      })
  #      client.statuses.update! :status=>"I #mightbuy #{Topic.find_by_shortcode(params[:sc]).subject}. Should I? http://mightbuy.it/topics/#{params[:sc]}?r=t"
  #    end
  #    if current_user.facebook_uid then
  #      puts "it is: http://mightbuy.it#{url_for(Topic.find_by_shortcode(params[:sc]))}"
  #      me = FbGraph::User.me("AAAGkC4pp4T0BAJY5LiuWtfHTEUYnWPVNnmdqN0Nc38As0r3vVWhDlbsgDnOTNWiCGKzP1Pue523bEQ1rR6jmI7IW9QtF89Dn5oOYPgZDZD")
  #      action = me.og_action!(
  #        "mightbuy:might_buy",
  #        :product => "http://mightbuy.it/topics/#{params[:sc]}"
  #      )
  #      flash[:notice] = "Friends Asked"
  #      redirect_to "http://mightbuy.it/topics/#{params[:sc]}"
  #    else
  #      redirect_to "/users/auth/facebook"
  #    end
  #  end
  
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
