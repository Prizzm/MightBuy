class HavesController < ApplicationController
  layout :choose_layout

  def index
    @haves = current_user.topics.have
  end

  def show
    @have = current_user.haves.find_by_shortcode(params[:id])
  end

  def copy
    @topic = Topic.find_by_shortcode(params[:id])
    @have = @topic.copy(current_user)
    @have.status = "ihave"

    unless @have.save
      flash[:error] = "Unable to add to list"
      redirect :back
    end
  end

  def create
    @have = Topic.new(params[:have])
  end

  def new
    @have = current_user.haves.build()
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

  def set_selected_tab
    @selected_tab = 'ihave'
  end
end
