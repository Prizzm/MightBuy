class WebsiteController < ApplicationController  
  
  def about
    render :layout => "application"
  end
  
  private
    
    helper_method :brand?
  
    def brand?
      params[:shopper] != true
    end
  
end