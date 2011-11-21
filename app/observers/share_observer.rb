class ShareObserver < ActiveRecord::Observer
  
  observe Shares::Share
  
  def after_create (share)
    case share
      when Shares::Email
        Notifications.share(share).deliver
    end
  end
  
end