class TopicsController < ApplicationController
  # Pageless
  index_with_xhr

  # Authenticate
  authenticate! :except => [:index, :show]
  before_filter :find_topic!, only: [:show, :update, :edit, :destroy]
  before_filter :authenticate_user!, :find_current_user_topic!, only: [:recommend, :ihave]
  before_filter :authenticate_user!, only: :haves

  respond_to :html, :js

  # Custom Actions
  layout :choose_layout

  # Verify Owner
  before_filter :only => [:edit, :update, :destroy] do
    unless @topic.user == current_user
      redirect_to login_path
    end
  end

  def feedback
    new!
  end

  def new
    @topic = Topic.new(params[:topic])
    @selected_tab = @topic.ihave? ? 'ihave' : 'mightbuy'
  end

  def index
    page = params[:page] || 1
    @topics = Topic.except_user_topics(page,current_user)
    if request.xhr?
      render :partial => "/topics/topic_list"
    end
  end

  def show
    @vote = @topic.votes.find_by_user_id(current_user.id) if current_user
    @comments = @topic.comments.joins(:user).where(parent_id: nil).includes(:user)
    @comment = @topic.comments.build

    if current_user && @topic.owner?(current_user)
      @selected_tab = @topic.ihave? ? 'ihave' : 'mightbuy'
    else
      @selected_tab = "everybody"
      render template: "/topics/other_user_topic"
    end
  end

  def copy
    @old_topic = Topic.find_by_shortcode(params[:id])
    @topic = @old_topic.copy(current_user)
    if @topic.save
      flash[:notice] = "Item copied to your list"
      redirect_to topic_path(@topic)
    else
      flash[:error] = "Failed to copy item"
      redirect_to topic_path(@old_topic)
    end
  end

  def create
    @topic = Topic.build_from_form_data(params['topic'],current_user,visitor_code)
    @topic.save
    respond_with(@topic)
  end

  def edit
    @selected_tab = 'mightbuy'
  end

  def recommend
    recommendable = params[:recommend] == "yes"
    if @topic.update_attributes(recommendable: recommendable)
      flash[:notice] = "Recommendation Updated"
    else
      flash[:error]  = "Failed to Update Recommendation"
    end

    respond_with(@topic)
  end

  def haves
    @topics = current_user.topics.have
    @selected_tab = "ihave"
  end

  def ihave
    status = (params[:ihave] == "yes" ? "ihave" : "imightbuy")
    if @topic.update_attributes(status: status)
      flash[:notice] = "Topic Updated"
    else
      flash[:error]  = "Failed to Update Topic"
    end

    @selected_tab = @topic.ihave? ? 'ihave' : 'mightbuy'
    respond_with(@topic)
  end

  def update
    @topic.update_from_form_data(params['topic'],visitor_code)
    respond_with @topic
  end

  def destroy
    @topic.destroy
    flash[:notice] = "The item has been removed"
    redirect_to profile_path()
  end

  protected
  def search
    if params[:user]
      owner = current_user.id == params[:user].to_i
      search = end_of_association_chain.where(:user_id => params[:user])
      owner ? search : search.publics
    else
      end_of_association_chain.publics
    end
  end

  private

  helper_method :featured_response, :responses
  def featured_response
    unless params[:feature].blank?
      @response ||= @topic.responses.find_by_id(params[:feature])
    end
  end

  def choose_layout
    current_user ? 'logged_user' : 'anonymous'
  end

  def responses
    @responses ||= @topic.responses.joins(:user).includes(:replies).where(:reply_id => nil)
  end

  def find_topic!
    @topic = Topic.find_by_shortcode(params[:id])
  end
end
