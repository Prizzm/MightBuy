class ResponseObserver < ActiveRecord::Observer
  
  def after_create (response)
    if response.user
      response.user.points.add :responding, :allocatable => response.topic
    end
    
    unless response.reply_to_email.blank?
      Notifications.responded(response).deliver
    end
  end
  
  # Only allow one level of replies & store reply to email..
  def before_validation (response)
    reply = response.reply
    
    if reply
      response.reply_to_email = reply.email_address
      response.reply_id = reply.reply_id if reply.reply_id?
    else
      response.reply_to_email = response.topic.user.email
    end    
  end
  
end