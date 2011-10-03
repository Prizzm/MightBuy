module Brands::InvitesHelper
  
  def header_for (action)
    case action
      when :index then "Feedback Invites"
      when :new then "Invite someone to give feedback."
      when :edit then "Updating your Invite"
      when :show then "Requested Feedback For"
      else super(action)
    end
  end
  
end