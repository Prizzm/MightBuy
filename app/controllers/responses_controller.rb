class ResponsesController < InheritedResources::Base
  
  # Relationships
  belongs_to :topic, :finder => :find_by_shortcode!
  
  def create
    @repsonse = build_resource
    @response.user = current_user
    @response.visitor_code = visitor_code
    @response.share = related_share
    
    create! do |success, failure|
      success.html { redirect_to topic_path(parent) }
      success.js do
        case parent.form
          when "recommendation"
            render "responses/recommendation/create"
          else render "create"
        end
      end
      success.js
      failure.js { render 'error' }
    end
  end
  
  private
  
    def related_share
      if !current_user && cookies.has_key?(:share_code)
        @related_share ||= Shares::Share.find_by_shortcode(cookies[:share_code])
      end
    end

end