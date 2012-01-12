module TopicsHelper

  def title
    case action_name
      when :show then super truncate(resource.subject, :length => 50)
      when :index then super "Latest Topics"
      when :new, :create then super "Start a Topic"
      when :edit, :update then super "Update your Topic"
    end
  end

  def shared_this (share, format = nil)
    case share
      when Shares::Email
        type   = :email
        with   = mail_to(share.with)
        format ||= "%s shared this with %s %s."
      when Shares::Tweet
        with   = nil
        type   = :tweet
        format ||= "%1$s tweeted about this %3$s."
      when Shares::Recommend
        with = nil
        type = :recommend
        format ||= "%1$s recommend this on facebook %3$s."
    end
    
    info = user_info(share.user)
    user_link = link_to(info[:name], info[:path], :class => "user")
    created_at = content_tag( :span, shorthand(share.created_at).downcase, :class => "created-at" )
    
    content_tag :div, :class => "share #{type}" do
      (format % [ user_link, with, created_at ]).html_safe
    end
  end
  
  def said_this (response, format = nil)
     if response.is_a?(Response)
      name = response.user ? response.user.name : (response.share ? response.share.with : "Guest" )
      path = response.user ? user_path(response.user) : "#guest"
      ((format || "%s said this %s.") % [
        link_to(name, path, :class => "user"),
        content_tag( :span, shorthand(response.created_at).downcase, :class => "created-at" )  
      ]).html_safe
    else 
      super(response, format)
    end
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
      when :new, :create
        case resource.form.to_s.to_sym
          when :recommendation then "Get Recommendations.."
          when :recommend then "Recommend a Product.."
          else "What's on your mind?"
        end
      when :feedback then "Get Feedback on A Product"
      else super
    end
  end
  
  def form_partial_for (topic)
    "topics/forms/%s" %
      case topic.form.to_s.to_sym
        when :recommendation then "recommendation"
        when :recommend then "recommend"
        else "default"
      end    
  end
  
  def quick_links
    case action_name
      when :show
        if resource.user == current_user
          link_to("Invite Others", new_topic_share_path(resource), :class => "button") +
          link_for(:edit, "Update") +
          link_for(:delete, "Remove")
        else
          link_to("Invite Others", new_topic_share_path(resource), :class => "button")
        end
      else super
    end
  end
  
  def response_form_for (topic, &block)
    html = user_signed_in? ? {} : { "data-remote" => true }
    url    = topic_responses_path(topic, :format => user_signed_in? ? nil : :js)
    simple_form_for Response.new, :url => url, :html => html, &block
  end
  
  def open_graph_info
    case action_name
      when :show
        super.merge \
          :image => image_url_for(resource, :thumb),
          :desc  => truncate(resource.body, :length => 100)
      else super
    end
  end

end