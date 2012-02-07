module WebsiteHelper
  
  include NotificationsHelper
  
  def header
    case action_name
      when :contact then "Contact Us"
      when :about   then "About Us"
      when :privacy then "Our Privacy Policy"
    end
  end
  
end