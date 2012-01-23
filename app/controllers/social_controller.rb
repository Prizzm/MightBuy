class SocialController < ApplicationController
  
  require 'cgi'
  require 'uri'
  
  skip_filter :award_points
  
  def tweeted
    
    topic = get_topic_for(URI.parse(params[:url]).fragment)

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
    
    topic = get_topic_for(params[:url])
    
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
  
  private
  
    def get_topic_for (url)
      prizzm_url?(url) ? 
        Topic.find_by_shortcode(parse_params_for(url)[:id]) :
        Topic.find_by_url(url)
    end
  
    def parse_params_for (url)
      attrs = {}.tap do |hash|
        uri = URI.parse(params[:url])
        hash.merge! Rack::Utils.parse_query(uri.query)
        hash.merge! Rails.application.routes.recognize_path(uri.path, :method => :get)
      end.symbolize_keys
    end
  
    def prizzm_url? (url)
      URI.parse(request.url).host == URI.parse(url).host
    end
  
end