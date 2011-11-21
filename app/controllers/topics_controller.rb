class TopicsController < InheritedResources::Base

  # Verify Owner
  before_filter :only => [:edit, :update, :destroy] do
    unless resource.user == current_user
      raise Exceptions::AccessDenied
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
  
end