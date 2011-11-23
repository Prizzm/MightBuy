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
          link_to("Share This", new_topic_share_path(resource)) +
          link_for(:edit, "Update") +
          link_for(:delete, "Remove")
        else
          link_to("Share This", new_topic_share_path(resource))
        end
      else super
    end
  end
  
  def response_form_for (&block)
    html = user_signed_in? ? {} : { "data-remote" => true }
    url    = topic_responses_path(resource, :format => user_signed_in? ? nil : :js)
    simple_form_for resource.responses.new, :url => url, :html => html, &block
  end

end