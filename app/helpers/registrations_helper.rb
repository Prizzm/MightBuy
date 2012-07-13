module RegistrationsHelper
  
  def quick_links
  end
  
  def brand_signup?
    !params[:brand].blank?
  end
  
end