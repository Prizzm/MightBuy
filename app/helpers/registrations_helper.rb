module RegistrationsHelper
  
  def brand_signup?
    !params[:brand].blank?
  end
  
end