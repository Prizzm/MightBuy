class SocialController < ApplicationController
  
  skip_filter :award_points
  
  def askfriends
      me = FbGraph::User.me("AAAGkC4pp4T0BAI1upGuC5CX7l0nRZA4QIocuUtlnGLMB0TFV5gUszMfeAAR4TzGWkt4MSedHfFiEKh4QduvnwPK1IdsA1B7od6WEA7AZDZD")
      action = me.og_action!(
        "mightbuy:might_buy",
        :product => "http://mightbuy.it#{url_for(Topic.find_by_shortcode(params[:sc]))}"
      )
      puts "it is: http://mightbuy.it#{url_for(Topic.find_by_shortcode(params[:sc]))}"
      redirect_to "http://mightbuy.it#{url_for(Topic.find_by_shortcode(params[:sc]))}"

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
