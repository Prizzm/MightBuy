class RestfulController < InheritedResources::Base
  
  def index
    respond_to do |wants|
      wants.html do
        !request.xhr? ? 
          render("application/index") : 
          render("index.xhr", :layout => false)
      end
    end
  end
  
  private
  
    helper_method :paginated
    
    def paginated
      @pagination ||= collection.page(params[:page]).per(10)
    end
  
end