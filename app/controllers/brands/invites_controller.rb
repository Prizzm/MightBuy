class Brands::InvitesController < Brands::BaseController

  defaults :resource_class => Invites::Feedback
  
  def begin_of_association_chain
    current_brand
  end
  
end