module TopicsHelper

  def header
    case action_name
      when :index then "Latest Topics.."
      when :show then phrase_for(:header)
      when :new then "What's on your mind?"
      else super
    end
  end
  
  def quick_links
    case action_name
      when :show
        if resource.user == current_user
          link_for(:edit, "Update") +
          link_for(:delete, "Remove") +
          link_to("Share This", new_topic_share_path(resource))
        else
          link_to("Share This", new_topic_share_path(resource))
        end
      else super
    end
  end

end