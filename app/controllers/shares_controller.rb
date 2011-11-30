class SharesController < InheritedResources::Base

  # Relationships
  belongs_to :topic, :finder => :find_by_shortcode!
  
  # Actions
  actions :new, :create

  protected
  
    def build_resource
      @share ||= Shares::Email.new(params[:shares_email]).tap do |share|
        share.topic = parent
        share.user = current_user
        share.visitor_code = visitor_code
      end
    end
  
end