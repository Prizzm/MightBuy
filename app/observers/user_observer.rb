class UserObserver < ActiveRecord::Observer
  
  def before_validation (user)
    user.password_confirmation = user.password
  end
  
end