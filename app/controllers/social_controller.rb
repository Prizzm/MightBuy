class SocialController < ApplicationController
  
  skip_filter :award_points
  before_filter :findTopic
  
    # Accessible Methods (fold)
      def socialAuthenticationAPI
        authenticate_using_facebook_uid(params[:uid])
      end      
      def askAllAPI
        post_to_open_graph(false)
        post_to_facebook_feed(false)
        post_to_twitter(false)
      end
      def facebook
        post_to_open_graph(true)
        post_to_facebook_feed(true)
        redirect_to "http://mightbuy.it/topics/#{@topic.shortcode}", :only_path => true
      end
      def twitter
        post_to_twitter(true)
        redirect_to "http://mightbuy.it/topics/#{@topic.shortcode}", :only_path => true
      end
      def askAll
        post_to_open_graph(false)
        post_to_facebook_feed(false)
        post_to_twitter(false)
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
                  :product => "http://mightbuy.it/topics/#{params[:sc]}",
                  :price => Topic.find_by_shortcode(params[:sc]).price.to_s
                )
               else
                 puts "price not ok"
                # If not, don't pass price into Open Graph
                action = me.og_action!(
                  "mightbuy:might_buy",
                  :product => "http://mightbuy.it/topics/#{params[:sc]}"
                )
               end
            # If a exception occurs, rescue
            rescue Exception => e
              # Rescue code here
              puts "exception occured: ", e
            end
          # If FB user doesn't exist
          else
            # Check if application should redirect (defined as param)
            if redirect == true then
              # If it should call redirect_to_social_login with the param of :facebook (redirect to facebook login)
              redirect_to_social_login(:facebook)
            end
          end
        end
        def post_to_facebook_feed(redirect = false)
          # Check if current_user has a Facebook account linked
          if current_user.hasFacebook? then
            # Begin rescue block
            begin
                # displayPrice = "for #{price}"
                me.feed!(
                  :message => "I MightBuy a #{@topic.subject} #{@topic.displayPrice}.  Should I?",
                  :picture => @topic.iImage(),
                  :link => "http://mightbuy.it/topics/#{params[:sc]}?r=t",
                  :name => "MightBuy",
                  :description => "Track stuff you mightbuy."
                )
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
            render :text => {:token => User.find_by_facebook_uid(params[:token]).authentication_token}.to_json
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
      # Facebook (end)
      
      # Twitter (fold)
        def post_to_twitter(redirect = false)
        # Check if current_user has Twitter account linked
        if current_user.hasTwitter? then
          # Begin rescue block
          begin
            # Create a new Grackle Client (New Twitter Client)
            client = Grackle::Client.new(:auth=>{
              :type=>:oauth,
              :consumer_key=>'kLGDHfctWCOTax3IY0Nwig', :consumer_secret=>'vP2xNwMj4jpntS6qN8Z37fY1qUTSk1vDgJT8b1HSs',
              :token=>current_user.twitter_oauth_token, :token_secret=>current_user.twitter_oauth_secret
            })
            # Post a status update
            client.statuses.update! :status=>"I #mightbuy #{@topic.subject} #{@topic.displayPrice}. Should I? http://mightbuy.it/topics/#{params[:sc]}?r=t"
          # Rescue from any exception
          rescue Exception => e
          end
        end
      # If current_user doesn't have a Twitter account linked ...
      else
        # Check if redirect is true (redirect defined as param)
        if redirect == true then
          # If so, redirect to Twitter login
          redirect_to_social_login(:twitter)
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
      # Other (end)
    # Backend Methods (end)
    
  
end
