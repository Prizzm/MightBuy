class ResponsesController < InheritedResources::Base
  
  # Relationships
  belongs_to :topic, :finder => :find_by_shortcode!
  
  def create
    @repsonse = build_resource
    @response.user = current_user
    create! { topic_path(parent) }
  end
  
end