class TopicsController < ApplicationController
  # Pageless
  index_with_xhr

  # Authenticate
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_topic_by_id!, :redirect_to_have!, only: :show
  before_filter :find_current_user_topic!, only: [:bought, :update, :edit, :destroy]

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
    @topics = Topic.except_user_topics(page)
    if request.xhr?
      render :partial => "/topics/topic_list"
    end
  end

  def show
    @vote = @topic.votes.find_by_user_id(current_user.id) if current_user
    @comments = @topic.ordered_comments
    @comment = Comment.new

    if current_user && @topic.owner?(current_user)
      @selected_tab = 'mightbuy'
    else
      @selected_tab = "everybody"
      render template: "/topics/other_user_topic"
    end
  end

  def bought
    @topic.status = "ihave"
    @selected_tab = "ihave"
    @have = @topic
    render file: "haves/copy"
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

    redirect_path = @topic.ihave? ? have_path(@topic) : topic_path(@topic)
    respond_with(@topic, location: redirect_path)
  end

  def edit
    @selected_tab = 'mightbuy'
  end

  def update
    @topic.update_from_form_data(params['topic'],visitor_code)

    redirect_path = @topic.ihave? ? have_path(@topic) : topic_path(@topic)
    respond_with(@topic, location: redirect_path)
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

  def redirect_to_have!
    if @topic.ihave?
      redirect_to have_path(@topic)
    end
  end
end
