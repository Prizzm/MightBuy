class UsersController < InheritedResources::Base
  
  actions :index, :show
  
  protected
  
    def collection
      @users ||= end_of_association_chain.order(:name)
    end
  
end