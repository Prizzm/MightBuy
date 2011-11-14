module Brands::MeHelper
  
  def header
    case action_name
      when :show then "Your Profile"
      when :edit then "Updating Your Profile"
    end
  end
  
  def quick_links
    case action_name
      when :show
        link_for(:edit, "Update Your Profile")
      else super
    end
  end
  
end