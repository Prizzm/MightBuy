class SocialController < ApplicationController
  
  require 'cgi'
  require 'uri'
  
  skip_filter :award_points
  
  def tweeted
    
    attrs = {}.tap do |hash|
      url = URI.parse(params[:url]).fragment
      uri = URI.parse(Rack::Utils.parse_query(url)["url"])
      hash.merge! Rack::Utils.parse_query(uri.query)
      hash.merge! Rails.application.routes.recognize_path(uri.path, :method => :get)
    end.symbolize_keys

    Shares::Tweet.create \
      :topic => Topic.find_by_shortcode(attrs[:id]),
      :user  => current_user,
      :visitor_code => visitor_code
      
    award_points
      
    respond_to do |wants|
      wants.js { render "points" }
    end

  end
  
  def recommended
    
    attrs = {}.tap do |hash|
      uri = URI.parse(params[:url])
      hash.merge! Rack::Utils.parse_query(uri.query)
      hash.merge! Rails.application.routes.recognize_path(uri.path, :method => :get)
    end.symbolize_keys
    
    Shares::Recommend.create \
      :topic => Topic.find_by_shortcode(attrs[:id]),
      :user => current_user,
      :visitor_code => visitor_code
      
    award_points
      
    respond_to do |wants|
      wants.js { render "points" }
    end
    
  end
  
end