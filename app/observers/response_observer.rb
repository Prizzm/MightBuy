class ResponseObserver < ActiveRecord::Observer
  
  def after_create (response)
    if response.user
      response.user.points.add :responding, :allocatable => response
    end
    
    if response.user != response.topic.user
      Notifications.responded(response).deliver
    end
  end
  
end