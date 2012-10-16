class UsersController < ApplicationController
  before_filter  :find_user!, :set_selected_tab
  layout 'logged_user'

  # Authenticate
  before_filter :authenticate_user!
  def show
    @topics = @user.topics.order("created_at desc").limit(12)
    @timeline_events = @user.timeline_events.order("created_at desc").limit(50)
  end

  private
  def find_user!
    unless @user = User.find(params[:id])
      redirect_to root_path
    end
  end

  def set_selected_tab
    @selected_tab = current_user == @user ? 'mightbuy' : 'everybody'
  end
end
