class ShareObserver < ActiveRecord::Observer
  
  observe Shares::Share
  
  def before_validation (share)
    share.shortcode ||= Shortcode.new
  end
  
  def after_create (share)
    case share
      when Shares::Email
        Notifications.share(share).deliver
    end
  end
  
end