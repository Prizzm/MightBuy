module TopicsHelper

  def shared_this (share, format = nil)
    info = user_info(share.user)
    ((format || "%s shared this with %s %s.") % [
      link_to(info[:name], info[:path], :class => "user"),
      mail_to(share.with),
      content_tag( :span, shorthand(share.created_at).downcase, :class => "created-at" )  
    ]).html_safe
  end
  
  def shares_for_topic
    case 
      when owner_of_topic? then resource.shares
      else resource.shares.where(:user_id => current_user)
    end
  end
  
  def owner_of_topic?
    current_user == resource.user
  end

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
          link_to("Share This", new_topic_share_path(resource), :class => "button") +
          link_for(:edit, "Update") +
          link_for(:delete, "Remove")
        else
          link_to("Share This", new_topic_share_path(resource), :class => "button")
        end
      else super
    end
  end
  
  def response_form_for (&block)
    html = user_signed_in? ? {} : { "data-remote" => true }
    url    = topic_responses_path(resource, :format => user_signed_in? ? nil : :js)
    simple_form_for Response.new, :url => url, :html => html, &block
  end

end