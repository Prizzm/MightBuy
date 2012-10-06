class HavesController < ApplicationController
  layout :choose_layout
  before_filter :find_topic!, only: [:show, :update, :edit, :destroy, :bought]

  def index
    @haves = current_user.topics.have
    @selected_tab = "ihave"
  end

  def show
    @have = current_user.haves.find_by_shortcode(params[:id])
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

  def find_topic!
    unless @topic = Topic.find_by_shortcode(params[:topic_id])
      respond_with(@topic, location: root_path)
    end
  end
end
