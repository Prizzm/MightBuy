class ResponsesController < InheritedResources::Base
  
  # Relationships
  belongs_to :topic, :finder => :find_by_shortcode!
  
  def create
    @repsonse = build_resource
    @response.user = current_user
    create! do |success, failure|
      success.html do
        give_points_for(:responding, :allocatable => parent)
        redirect_to topic_path(parent)
      end
    end
  end
  
end