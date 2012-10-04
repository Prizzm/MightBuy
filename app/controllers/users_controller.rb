class UsersController < ApplicationController
  layout 'logged_user'

  # Authenticate
  before_filter :authenticate_user!
  def show
    @user = User.find(params[:id])
  end

  private
  def set_selected_tab
    @selected_tab = 'mightbuy'
  end
end

