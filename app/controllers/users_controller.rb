class UsersController < ApplicationController
  before_filter  :find_user!, :set_selected_tab
  layout 'logged_user'

  def show
    @topics = @user.topics.mightbuy.order("created_at desc").limit(6)
    @haves  = @user.topics.have.order("created_at desc").limit(6)
    @timeline_events = @user.timeline_events.order("created_at desc").limit(50)
  end

  private
  def find_user!
    if params[:id] =~ /^[0-9]+$/
      @user = User.find_by_id(params[:id])
    else
      @user = User.find_by_slug(params[:id])
    end

    unless @user
      redirect_to root_path, alert: 'User does not exist'
    end
  end

  def set_selected_tab
    @selected_tab = current_user == @user ? 'mightbuy' : 'everybody'
  end
end
