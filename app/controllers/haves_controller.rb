class HavesController < ApplicationController
  layout :choose_layout

  def index
    @haves = current_user.topics.have
    @selected_tab = "ihave"
  end

  def show
    @have = current_user.haves.find_by_shortcode(params[:id])
    @selected_tab = "ihave"
  end

  def new
    @topic = Topic.find_by_shortcode(params[:id])
    @have = Topic.new(@topic.attributes)
    @selected_tab = "ihave"
  end

  def edit

  end

  def destroy
    @topic.destroy
    flash[:notice] = "The item has been removed"
    redirect_to profile_path()
  end

  private
  def choose_layout
    current_user ? 'logged_user' : 'anonymous'
  end
end
