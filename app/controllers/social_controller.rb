class SocialController < ApplicationController
  
  skip_filter :award_points
  before_filter :findTopic
  # REFACTOR
    # Facebook
    def postToOpenGraph
      begin
        # Create FB User Object
        me = FbGraph::User.me(current_user.facebook_oauth_token)
        # Check if topic has a price
        if @topic.price then
          # If so, pass price into Open Graph
          action = me.og_action!(
            "mightbuy:might_buy",
            :product => "http://mightbuy.it/topics/#{params[:sc]}",
            :price => Topic.find_by_shortcode(params[:sc]).price.to_str
          )
         else
          # If not, don't pass price into Open Graph
          action = me.og_action!(
            "mightbuy:might_buy",
            :product => "http://mightbuy.it/topics/#{params[:sc]}"
          )
         end
      # If a exception occurs, rescue
      rescue Exception
        # Rescue code here
      end
    end
    
    def postToFacebookFeed
      begin
          if @topic.iImage() != nil then
            if @topic.price then
              me.feed!(
                :message => "I MightBuy a #{@topic.subject} for #{@topic.price}.  Should I?",
                :picture => Topic.find_by_shortcode(params[:sc]).image.url(:host => "http://mightbuy.it"),
                :link => "http://mightbuy.it/topics/#{params[:sc]}?r=t",
                :name => "MightBuy",
                :description => "Track stuff you mightbuy."
              )
            else
              me.feed!(
                :message => "I MightBuy a #{Topic.find_by_shortcode(params[:sc]).subject}.  Should I?",
                :link => "http://mightbuy.it/topics/#{params[:sc]}?r=t",
                :name => "MightBuy",
                :description => "Track stuff you mightbuy."
              )
            end
          else
            if @topic.price then
              me.feed!(
                 :message => "I MightBuy a #{Topic.find_by_shortcode(params[:sc]).subject}.  Should I?",
                 :picture => Topic.find_by_shortcode(params[:sc]).image.url(:host => "http://mightbuy.it"),
                 :link => "http://mightbuy.it/topics/#{params[:sc]}?r=t",
                 :name => "MightBuy",
                 :description => "Track stuff you mightbuy."
               )
            else
              me.feed!(
                 :message => "I MightBuy a #{Topic.find_by_shortcode(params[:sc]).subject} for #{Topic.find_by_shortcode(params[:sc]).price}.  Should I?",
                 :picture => Topic.find_by_shortcode(params[:sc]).image.url(:host => "http://mightbuy.it"),
                 :link => "http://mightbuy.it/topics/#{params[:sc]}?r=t",
                 :name => "MightBuy",
                 :description => "Track stuff you mightbuy."
               )
            end
               end
            end #post without pic since there is no image url
       rescue Exception => e
         error = e
       end
    end
    
    def findTopic
      @topic = Topic.find_by_shortcode(params[:sc])
    end


  # OLD
  
  def getShortCode
    topic = Topic.find_by_mobile_image_url(params[:miu])
    if topic
      render :text => topic.shortcode
    else
      
    end
  end
  
  def askMobileFriends
    user = User.find_by_authentication_token(params[:auth_token])
    if user.facebook_uid && user.facebook_oauth_token
       begin
         me = FbGraph::User.me(user.facebook_oauth_token)
         action = me.og_action!(
                "mightbuy:might_buy",
                :product => "http://mightbuy.it/topics/#{params[:sc]}",
:price => "#{Topic.find_by_shortcode(params[:sc]).price}"
              )
         me.feed!(
              :message => "I MightBuy a #{Topic.find_by_shortcode(params[:sc]).subject}.  Should I?",
              :picture => Topic.find_by_shortcode(params[:sc]).image.url(:host => "http://mightbuy.it"),
              :link => "http://mightbuy.it/topics/#{params[:sc]}?r=t",
              :name => "MightBuy",
              :description => "Track stuff you mightbuy."
          )
        rescue Exception => e
          error = e
        end
    end
    
    if user.twitter_uid && user.twitter_oauth_token && user.twitter_oauth_secret then
      begin
        client = Grackle::Client.new(:auth=>{
          :type=>:oauth,
          :consumer_key=>'kLGDHfctWCOTax3IY0Nwig', :consumer_secret=>'vP2xNwMj4jpntS6qN8Z37fY1qUTSk1vDgJT8b1HSs',
          :token=>user.twitter_oauth_token, :token_secret=>user.twitter_oauth_secret
        })
        client.statuses.update! :status=>"I #mightbuy #{Topic.find_by_shortcode(params[:sc]).subject}. Should I? http://mightbuy.it/topics/#{params[:sc]}?r=t"
      rescue Grackle::TwitterError => e
        
      end
    end
    render :text => "done"
  end
  
 def authenticateMobile
   if User.find_by_facebook_uid(params[:token]) then
     User.find_by_facebook_uid(params[:token]).ensure_authentication_token!
     render :text => {:token => User.find_by_facebook_uid(params[:token]).authentication_token}.to_json
   else
      u = User.new()
      u.facebook_uid = params[:token]
      u.name = "#{params[:first_name]} #{params[:last_name]}"
      u.email = params[:email]
      u.facebook_oauth_token = params[:oauth_token]
      u.save()
      u.ensure_authentication_token!
     render :text => {:token => u.authentication_token}.to_json
   end
 end
 
 def askTwitterFriends
   if current_user.twitter_uid && current_user.twitter_oauth_token && current_user.twitter_oauth_secret then
          begin
            client = Grackle::Client.new(:auth=>{
              :type=>:oauth,
              :consumer_key=>'kLGDHfctWCOTax3IY0Nwig', :consumer_secret=>'vP2xNwMj4jpntS6qN8Z37fY1qUTSk1vDgJT8b1HSs',
              :token=>current_user.twitter_oauth_token, :token_secret=>current_user.twitter_oauth_secret
            })
            if Topic.find_by_shortcode(params[:sc]).price then
              client.statuses.update! :status=>"I #mightbuy #{Topic.find_by_shortcode(params[:sc]).subject} for #{Topic.find_by_shortcode(params[:sc]).price}. Should I? http://mightbuy.it/topics/#{params[:sc]}?r=t"
            else
              client.statuses.update! :status=>"I #mightbuy #{Topic.find_by_shortcode(params[:sc]).subject}. Should I? http://mightbuy.it/topics/#{params[:sc]}?r=t"
            end
          rescue Grackle::TwitterError => e
          end
          redirect_to "http://mightbuy.it/topics/#{params[:sc]}?atf=t"
   end
   
   if !current_user.twitter_uid then
     redirect_to "/users/auth/twitter"
   end
 end
 
 def askFacebookFriends
   if current_user.facebook_uid && current_user.facebook_oauth_token
     error = nil
     begin
       me = FbGraph::User.me(current_user.facebook_oauth_token)
       if Topic.find_by_shortcode(params[:sc]).price then
         action = me.og_action!(
                "mightbuy:might_buy",
                :product => "http://mightbuy.it/topics/#{params[:sc]}",
                :price => Topic.find_by_shortcode(params[:sc]).price.to_str
              )
       else
         action = me.og_action!(
                "mightbuy:might_buy",
                :product => "http://mightbuy.it/topics/#{params[:sc]}"
              )
       end
      if !Topic.find_by_shortcode(params[:sc]).mobile_image_url  then
         if !Topic.find_by_shortcode(params[:sc]).image.blank? then
           if Topic.find_by_shortcode(params[:sc]).price then
             me.feed!(
                :message => "I MightBuy a #{Topic.find_by_shortcode(params[:sc]).subject} for #{Topic.find_by_shortcode(params[:sc]).price}.  Should I?",
                :picture => Topic.find_by_shortcode(params[:sc]).image.url(:host => "http://mightbuy.it"),
                :link => "http://mightbuy.it/topics/#{params[:sc]}?r=t",
                :name => "MightBuy",
                :description => "Track stuff you mightbuy."
              ) else
                me.feed!(
                  :message => "I MightBuy a #{Topic.find_by_shortcode(params[:sc]).subject} for #{Topic.find_by_shortcode(params[:sc]).price}.  Should I?",
                  :link => "http://mightbuy.it/topics/#{params[:sc]}?r=t",
                  :name => "MightBuy",
                  :description => "Track stuff you mightbuy."
                ) 
            else
              me.feed!(
                 :message => "I MightBuy a #{Topic.find_by_shortcode(params[:sc]).subject}.  Should I?",
                 :picture => Topic.find_by_shortcode(params[:sc]).image.url(:host => "http://mightbuy.it"),
                 :link => "http://mightbuy.it/topics/#{params[:sc]}?r=t",
                 :name => "MightBuy",
                 :description => "Track stuff you mightbuy."
               ) else
                 me.feed!(
                   :message => "I MightBuy a #{Topic.find_by_shortcode(params[:sc]).subject}.  Should I?",
                   :link => "http://mightbuy.it/topics/#{params[:sc]}?r=t",
                   :name => "MightBuy",
                   :description => "Track stuff you mightbuy."
                 )
               end
             end
          end #post without pic since there is no image url
          
      else
        me.feed!(
             :message => "I MightBuy a #{Topic.find_by_shortcode(params[:sc]).subject} for #{Topic.find_by_shortcode(params[:sc]).price}.  Should I?",
             :picture => Topic.find_by_shortcode(params[:sc]).mobile_image_url,
             :link => "http://mightbuy.it/topics/#{params[:sc]}?r=t",
             :name => "MightBuy",
             :description => "Track stuff you mightbuy."
         )
      end
     rescue Exception => e
       error = e
     end
     redirect_to "http://mightbuy.it/topics/#{params[:sc]}?aff=t", :flash => { :error => error }
   end
   if !current_user.facebook_uid then
     redirect_to "/users/auth/facebook"
   end
 end
 
 def askfriends
   if current_user.facebook_uid && current_user.facebook_oauth_token
     error = nil
     begin
       me = FbGraph::User.me(current_user.facebook_oauth_token)
       action = me.og_action!(
              "mightbuy:might_buy",
              :product => "http://mightbuy.it/topics/#{params[:sc]}",
              :price => Topic.find_by_shortcode(params[:sc]).price.to_str
            )
      if !Topic.find_by_shortcode(params[:sc]).mobile_image_url  then
         if !Topic.find_by_shortcode(params[:sc]).image.blank? then 
           me.feed!(
              :message => "I MightBuy a #{Topic.find_by_shortcode(params[:sc]).subject} for #{Topic.find_by_shortcode(params[:sc]).price}.  Should I?",
              :picture => Topic.find_by_shortcode(params[:sc]).image.url(:host => "http://mightbuy.it"),
              :link => "http://mightbuy.it/topics/#{params[:sc]}?r=t",
              :name => "MightBuy",
              :description => "Track stuff you mightbuy."
            ) else
              me.feed!(
                :message => "I MightBuy a #{Topic.find_by_shortcode(params[:sc]).subject} for #{Topic.find_by_shortcode(params[:sc]).price}.  Should I?",
                :link => "http://mightbuy.it/topics/#{params[:sc]}?r=t",
                :name => "MightBuy",
                :description => "Track stuff you mightbuy."
              ) 
          
          end #post without pic since there is no image url
          
      else
        me.feed!(
             :message => "I MightBuy a #{Topic.find_by_shortcode(params[:sc]).subject} for #{Topic.find_by_shortcode(params[:sc]).price}.  Should I?",
             :picture => Topic.find_by_shortcode(params[:sc]).mobile_image_url,
             :link => "http://mightbuy.it/topics/#{params[:sc]}?r=t",
             :name => "MightBuy",
             :description => "Track stuff you mightbuy."
         )
      end
     rescue Exception => e
       error = e
     end
     redirect_to "http://mightbuy.it/topics/#{params[:sc]}?af=t", :flash => { :error => error }
   end
   
   if current_user.twitter_uid && current_user.twitter_oauth_token && current_user.twitter_oauth_secret then
          begin
            client = Grackle::Client.new(:auth=>{
              :type=>:oauth,
              :consumer_key=>'kLGDHfctWCOTax3IY0Nwig', :consumer_secret=>'vP2xNwMj4jpntS6qN8Z37fY1qUTSk1vDgJT8b1HSs',
              :token=>current_user.twitter_oauth_token, :token_secret=>current_user.twitter_oauth_secret
            })
            client.statuses.update! :status=>"I #mightbuy #{Topic.find_by_shortcode(params[:sc]).subject}for #{Topic.find_by_shortcode(params[:sc]).price}. Should I? http://mightbuy.it/topics/#{params[:sc]}?r=t"
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
  #        :product => "http://mightbuy.it/topics/#{params[:sc]}",
:price => "#{Topic.find_by_shortcode(params[:sc]).price}"
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
