class HavesController < ApplicationController
  layout :choose_layout
  before_filter :authenticate_user!, only: [:copy, :recommend, :edit, :create, :destroy]
  before_filter :find_current_user_topic!, only: [:edit, :recommend, :destroy]

  def index
    @haves = current_user.topics.have
  end

  def show
    @have = current_user.haves.find_by_shortcode(params[:id])
    @comments = @have.comments
    @comment = Comment.new()
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

  def recommend
    recommendation = params[:recommend] == "yes" ? "recommended" : "not-recommended"
    if @topic.update_attributes(recommendation: recommendation)
      flash[:notice] = "Recommendation Updated"
    else
      flash[:error]  = "Failed to Update Recommendation"
    end
    respond_with(@topic)
  end

  def destroy
    flash[:notice] = "The item has been removed"
    respond_with(@topic.destroy, location: haves_path)
  end

  private
  def choose_layout
    current_user ? 'logged_user' : 'anonymous'
  end

  def set_selected_tab
    @selected_tab = 'ihave'
  end

  def find_current_user_topic!
    unless @topic = current_user.topics.find_by_shortcode(params[:id])
      redirect_to root_path
    end
  end
end
