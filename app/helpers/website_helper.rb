module WebsiteHelper
  
  include NotificationsHelper
  
  def header
    case action_name
      when :contact then "Contact Us"
      when :about   then "A Little About Us.."
      when :privacy then "Our Privacy Policy"
    end
  end
  
end