class HavesController < ApplicationController
  layout :choose_layout
  before_filter :authenticate_user!, only: [:copy, :recommend, :edit, :create, :destroy]
  before_filter :find_current_user_topic!, only: [:edit, :recommend, :destroy]
  before_filter :find_topic_by_id!, :redirect_to_mightbuy!, only: :show

  def index
    @haves = current_user.topics.have
  end

  def show
    @have = @topic
    @comments = @have.comments.joins(:user).where(parent_id: nil).includes(:user)
    @comment = @have.comments.build

    unless current_user && @have.owner?(current_user)
      @selected_tab = "everybody"
    end
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

  def redirect_to_mightbuy!
    unless @topic.ihave?
      redirect_to have_path(@topic)
    end
  end
end
