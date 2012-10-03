class WebsiteController < ApplicationController
  def index
    if current_user
      redirect_to "/me"
    end
  end

  private

  helper_method :brand?

  def brand?
    params[:shopper] != true
  end

end
