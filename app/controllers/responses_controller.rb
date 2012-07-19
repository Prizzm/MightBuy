class ResponsesController < InheritedResources::Base
  
  
  # Relationships
  belongs_to :topic, :finder => :find_by_shortcode!
  
  def index
    index! do |format|
      format.js
    end
  end
  
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
  
    def filter
      case params[:filter_by]
        when 'unreplied' then end_of_association_chain.unreplied
        when 'recommended' then end_of_association_chain.recommended
        when 'undecided' then end_of_association_chain.undecided
        when 'not_recommended' then end_of_association_chain.not_recommended
        else end_of_association_chain
      end
    end
  
    def collection
      @responses ||= filter.includes(:replies).where(:reply_id => nil)
    end
  
    def related_share
      if !current_user && cookies.has_key?(:share_code)
        @related_share ||= Shares::Share.find_by_shortcode(cookies[:share_code])
      end
    end

end