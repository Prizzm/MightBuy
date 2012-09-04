class WelcomesController < ApplicationController
  def index
    if current_user
      redirect_to "/me"
    end
  end
end
