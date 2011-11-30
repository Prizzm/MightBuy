module ProfileHelper
  
  def header
    case action_name
      when :show then "Your Profile"
      when :edit then "Updating Your Profile"
    end
  end
  
  def quick_links
    case action_name
      when :show
        link_for(:edit, "Update Your Profile") +
        link_to("Start a Topic", new_topic_path, :class => "button")
      else super
    end
  end
  
end