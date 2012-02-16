class WebsiteController < ApplicationController  
  
  private
    
    helper_method :brand?
  
    def brand?
      params[:shopper] != true
    end
  
end