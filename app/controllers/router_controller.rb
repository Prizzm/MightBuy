class RouterController < ApplicationController
  
  def invited
    cookies[:share_code] = share.shortcode
    redirect_to topic_path(share.topic, :responding => true)
  end
  
  def join_beta
    BetaSignup.new(params[:beta_signup]).tap do |signup|
      signup.visitor_code = cookies[:visitor_code]
    end.save
    
    respond_to do |wants|
      wants.js
    end
  end

  private
    
    def share
      @share ||= Shares::Share.find_by_shortcode!(params[:shortcode])
    end
  
end