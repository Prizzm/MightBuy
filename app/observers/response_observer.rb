class ResponseObserver < ActiveRecord::Observer
  
  def after_create (response)
    if response.user
      response.user.points.add :responding, :allocatable => response.topic
    end
    
    if response.user != response.topic.user
      Notifications.responded(response).deliver
    end
  end
  
  # Only allow one level of replies.
  def before_validation (response)
    reply = response.reply
    if reply && reply.reply_id?
      response.reply_id = reply.reply_id
    end
  end
  
end