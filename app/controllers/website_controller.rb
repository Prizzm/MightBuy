class WebsiteController < ApplicationController  
  
  def index
    redirect_to new_brand_session_path
  end
  
end