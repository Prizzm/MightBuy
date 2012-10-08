class UsersController < ApplicationController
  layout 'logged_user'

  # Authenticate
  before_filter :authenticate_user!
  def show
    @user = User.find(params[:id])
    @topics = @user.topics.order("created_at desc").limit(12)
    @timeline_events = @user.timeline_events.order("created_at desc").limit(50)
  end

  private
  def set_selected_tab
    @selected_tab = 'mightbuy'
  end
end

