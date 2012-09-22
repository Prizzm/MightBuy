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


  def latest_posts
    resource.topics.mightbuy.order("created_at desc").limit(10)
  end
  
  def latest_activity
    resource.responses.order("created_at desc").limit(2)
  end
  
end
