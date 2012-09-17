class TopicsController < ApplicationController
  # Pageless
  index_with_xhr

  # Authenticate
  authenticate! :except => [:index, :show]
  before_filter :find_topic!, only: [:show, :update, :edit, :destroy]

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
    @selected_tab = 'mightbuy'
  end

  def index
    page = params[:page] || 1
    @topics = Topic.order("created_at desc").page(page).per(10)
    if request.xhr?
      render :partial => "/topics/topic_list"
    end
  end

  def share
    @topic = current_user.topics.find_by_shortcode(params[:topic_id])
    @selected_tab = 'mightbuy'
  end

  def show
    @vote = @topic.votes.find_by_user_id(current_user.id) if current_user
    @comments = @topic.comments.joins(:user).where(parent_id: nil).includes(:user)
    @comment = @topic.comments.build
    @selected_tab = 'mightbuy'
  end

  def create
    @topic = Topic.create_from_from_data(params['topic'],current_user,visitor_code)
    @topic.save
    respond_with(@topic)
  end

  def edit
    @selected_tab = 'mightbuy'
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
