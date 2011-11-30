class ResponseObserver < ActiveRecord::Observer
  
  def after_create (response)
    if response.user
      response.user.points.add :responding, :allocatable => response
    end
  end
  
end