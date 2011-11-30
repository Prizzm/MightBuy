class UserObserver < ActiveRecord::Observer
  
  def before_validation (user)
    user.password_confirmation = user.password
  end
  
  def after_create (user)
    user.points.add :joining
  end
  
end