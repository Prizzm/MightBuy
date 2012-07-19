class TopicsController < RestfulController
  
  # Pageless
  index_with_xhr
  
  # Authenticate
  authenticate! :except => [:index, :show]
  
  # Custom Actions
  custom_actions :collection => :feedback, :resource => :share
  
  # Verify Owner
  before_filter :only => [:edit, :update, :destroy] do
    unless resource.user == current_user
      redirect_to login_path
    end
  end
  
  def feedback
    new!
  end
  
  def share
    edit!
  end
  
  def show
    puts "session[:oauth_token]: ", session[:oauth_token]
    show! do |format|
      format.html do
        if params[:responding]
          case resource.form?
            when :recommendation
              render "responding"
            when :business_recommendation
              render "responding"
            else render "show"
          end
        else
          render "show"
        end
      end
    end
  end
  
  def create
    @topic = build_resource
    @topic.user = current_user
    @topic.pass_visitor_code = visitor_code
    create!
    if current_user.facebook_uid then
      me = FbGraph::User.me("AAAGkC4pp4T0BAI1upGuC5CX7l0nRZA4QIocuUtlnGLMB0TFV5gUszMfeAAR4TzGWkt4MSedHfFiEKh4QduvnwPK1IdsA1B7od6WEA7AZDZD")
      action = me.og_action!(
        "mightbuy:might_buy",
        :product => "http://mightbuy.it#{url_for(@topic)}"
      )
    end
  end
  
  def update
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
    
    def responses
      @responses ||= resource.responses.includes(:replies).where(:reply_id => nil)
    end
  
end