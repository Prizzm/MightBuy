class InviteObserver < ActiveRecord::Observer
  
  observe Invites::Invite
  
  def after_create (invite)
    case invite
      when Invites::Feedback
        Notifications.feedback(invite).deliver
    end
  end
  
  def before_save (invite)
    invite.invitee.save(:validate => false)
    invite.invitee = invite.invitee
  end
  
  def before_validation (invite)
    invite.code ||= Devise.friendly_token[0,10].downcase
  end
  
end