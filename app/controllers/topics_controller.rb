class TopicsController < InheritedResources::Base
  
  # Authenticate
  authenticate! :except => [:index, :show]
  
  # Verify Owner
  before_filter :only => [:edit, :update, :destroy] do
    unless resource.user == current_user
      redirect_to login_path
    end
  end
  
  def create
    @topic = build_resource
    @topic.user = current_user
    create!
  end
  
  protected
  
    def collection
      @topics ||= end_of_association_chain.publics.order("created_at desc")
    end
    
    def resource
      @topic ||= end_of_association_chain.find_by_shortcode!(params[:id])
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