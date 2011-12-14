class RouterController < ApplicationController
  
  def invited
    cookies[:share_code] = share.shortcode
    redirect_to topic_path(share.topic, :responding => true)
  end
  
  private
    
    def share
      @share ||= Shares::Share.find_by_shortcode!(params[:shortcode])
    end
  
end