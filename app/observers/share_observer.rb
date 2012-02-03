class ShareObserver < ActiveRecord::Observer
  
  observe Shares::Share
  
  def before_validation (share)
    share.shortcode ||= Shortcode.new
    share.user ||= share.topic.user
    
    puts "beforevalid: #{share.inspect}"
  end
  
  def after_create (share)
    case share
      when Shares::Email
        Notifications.share(share).deliver
    end
    
    if share.user
      case share
        when Shares::Tweet
          share.user.points.add :tweeting, :allocatable => share.topic
        when Shares::Recommend
          share.user.points.add :recommending, :allocatable => share.topic
      end
    end
  end
  
end