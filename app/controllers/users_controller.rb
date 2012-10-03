class UsersController < ApplicationController
  layout 'logged_user'

  # Authenticate
  before_filter :authenticate_user!
  def show
    
  end
end
