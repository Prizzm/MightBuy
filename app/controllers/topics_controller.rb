class TopicsController < RestfulController
  # Pageless
  index_with_xhr

  # Authenticate
  authenticate! :except => [:index, :show]

  # Custom Actions
  custom_actions :collection => :feedback, :resource => :share
  layout :choose_layout

  # Verify Owner
  before_filter :only => [:edit, :update, :destroy] do
    unless resource.user == current_user
      redirect_to login_path
    end
  end
  def feedback
    new!
  end

  def index
    @topics = Topic.order("created_at desc").page(params[:page]).per(10)
    if request.xhr?
      render :partial => "topic_list"
      return
    end
  end

  def share
    edit!
  end

  def show
    show! do |format|
      format.html do
        if params[:responding] || params[:r]
          case resource.form?
          when :recommendation
            render "responding"
          when :business_recommendation
            render "responding"
          else
            render "show"
          end
        else
          render "show"
        end
      end
    end
  end

  def create
    # avoid bad URI error for non-standard URLs
    # https://www.pivotaltracker.com/story/show/34470735
    if params[:topic][:image_url] then
      params[:topic][:image_url] = URI.parse(URI.encode(params[:topic][:image_url])).to_s
    end
    @topic = build_resource
    @topic.user = current_user
    @topic.pass_visitor_code = visitor_code

    if params["topic"]["mobile_image_url"]
      dragon = Dragonfly[:images]
      @topic.image = dragon.fetch_url(params["topic"]["mobile_image_url"])
    end
    create!

    response.status = 302
  end

  def update
    if params[:topic][:image_url] && URI.parse(URI.encode(params[:topic][:image_url])).host
      params[:topic][:image_url] = URI.parse(URI.encode(params[:topic][:image_url])).to_s
    else
      params[:topic].delete(:image_url)
    end
    @topic = resource
    @topic.pass_visitor_code = visitor_code
    update!
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

  def collection
    @topics ||= search.order("created_at desc")
  end

  def resource
    @topic ||= end_of_association_chain.find_by_shortcode!(params[:id] || params[:topic_id])
  end

  private

  helper_method :share, :featured_response, :responses

  def share
    @share ||= Shares::Share.find_by_shortcode(cookies[:share_code])
  end

  def featured_response
    unless params[:feature].blank?
      @response ||= resource.responses.find_by_id(params[:feature])
    end
  end

  def choose_layout
    current_user ? 'logged_user' : 'anonymous'
  end

  def set_selected_tab
    if current_user
      @selected_tab = 'everybody'
    else
      @selected_tab = 'mightbuy'
    end
  end


  def responses
    @responses ||= resource.responses.joins(:user).includes(:replies).where(:reply_id => nil)
  end

end
