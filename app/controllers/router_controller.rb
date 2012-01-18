class RouterController < ApplicationController
  
  def invited
    cookies[:share_code] = share.shortcode
    redirect_to topic_path(share.topic, :responding => true)
  end
  
  def register
    share = Shares::Share.find_by_visitor_code!(cookies[:visitor_code]);
    share.update_attribute :registered, true
    respond_to do |wants|
      wants.js
    end
  end
  
  private
    
    def share
      @share ||= Shares::Share.find_by_shortcode!(params[:shortcode])
    end
  
end