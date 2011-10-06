class Brands::InvitesController < Brands::BaseController

  defaults :resource_class => Invites::Feedback
  
  protected
  
    def begin_of_association_chain
      current_brand
    end
  
    def collection
      @invites ||= end_of_association_chain.page(params[:page])
    end
  
end