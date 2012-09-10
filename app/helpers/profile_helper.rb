module ProfileHelper
  
  def header
    case action_name
      when :show then "I might buy"
      when :edit then "Updating Your Profile"
    end
  end
  
  def quick_links
    case action_name
      when :show
        #link_for(:edit, "Update Your Profile") +
        link_to("Add", new_topic_path, :class => "button")
      else super
    end
  end

  def avatar_image
    current_user.image ? current_user.image.url : "/assets/default_avatar.png"
  end
  
  def latest_posts
    resource.topics.order("created_at desc").limit(10)
  end
  
  def latest_activity
    resource.responses.order("created_at desc").limit(2)
  end
  
end