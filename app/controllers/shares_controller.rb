class SharesController < InheritedResources::Base

  # Relationships
  belongs_to :topic, :finder => :find_by_shortcode!
  
  # Actions
  actions :new, :create
  
  def create
    @resources = build_resources
    if resources.all?(&:valid?)
      resources.each(&:save)
      redirect_to parent_path
    else
      render "new"
    end
  end
    
  private
  
    helper_method :resources
    
    def resources 
      @resources ||= [ Shares::Email.new ]
    end
    
    def build_resources
      (params[:topic][:shares_attributes] || {}).map do |key, attributes|
        attributes.delete(:_destroy)
        Shares::Email.new(attributes).tap do |share|
          share.topic = parent
          share.user  = current_user
          share.visitor_code = visitor_code
        end
      end
    end
  
end