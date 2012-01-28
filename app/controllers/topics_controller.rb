class TopicsController < RestfulController
  
  # Authenticate
  authenticate! :except => [:index, :show]
  
  # Custom Actions
  custom_actions :collection => :feedback
  
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
    index!
  end
  
  def show
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
    @topic.shares = build_shares
    @topic.user = current_user
    create!
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
      @topic ||= end_of_association_chain.find_by_shortcode!(params[:id])
    end
  
  private
  
    def build_shares
      (params[:topic][:shares_attributes] || {}).map do |key, attributes|
        unless attributes[:with].blank?
          attributes.delete(:_destroy)
          Shares::Email.new(attributes).tap do |share|
            share.user  = current_user
            share.visitor_code = visitor_code
          end
        end
      end.compact
    end
    
  private
  
    helper_method :featured_response, :responses
  
    def featured_response
      unless params[:feature].blank?
        @response ||= resource.responses.find_by_id(params[:feature])
      end
    end
    
    def responses
      @responses ||= resource.responses.includes(:replies).where(:reply_id => nil)
    end
  
end