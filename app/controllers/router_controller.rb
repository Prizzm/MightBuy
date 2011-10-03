class RouterController < ApplicationController
  
  def invite
    case find_invite
      when Invites::Feedback
        login_anonymous_user!
        redirect_to product_feedback_path(@invite.reference)
    end
  end
  
  private
  
    def find_invite
      @invite ||= Invites::Invite.find_by_code!(params[:invite_code])
    end
    
    def login_anonymous_user!
      unless logged_in_as
        sign_in(@invite.invitee)
        @invite.update_attribute(:visited_at, Time.now)
      end
    end
    
    def logged_in_as
      current_brand || current_user
    end
  
end