class UserObserver < ActiveRecord::Observer
  
  def before_validation (user)
    user.password_confirmation = user.password
  end
  
  def after_save (user)
    unless user.photo.blank?
      user.points.add :uploading_a_photo
    end
  end
  
  def after_create (user)
    user.points.add :joining
  end
  
end