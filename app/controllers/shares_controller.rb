class SharesController < InheritedResources::Base

  # Relationships
  belongs_to :topic, :finder => :find_by_shortcode!
  
  # Actions
  actions :new, :create

  protected
  
    def build_resource
      @share ||= Shares::Email.new(params[:shares_email]).tap do |share|
        share.user = current_user
        share.topic = parent
      end
    end
  
end