module TopicsHelper

  def filter_url (type)
    topic_responses_path(resource, :filter_by => type, :format => :js)
  end

  def title
    case action_name
      when :show then super truncate(resource.subject, :length => 50)
      when :index then super "Latest Topics"
      when :new, :create then super "Start a Topic"
      when :edit, :update then super "Update your Topic"
    end
  end
  
  def respond_button (type, label, options = {})
    icon = options[:icon] ? image_tag('/images/icons/%s' % options[:icon]) : nil
    label = [ icon, label ].compact.join(' ').html_safe
    link_to label, 'javascript:void(0);', :class => ['button', type].join(' ')
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
      name = response.user ? response.user.name : (response.share ? (user_signed_in?? response.share.with : "Guest") : "Guest" )
      path = response.user ? user_path(response.user) : "#guest"
      ((format || "%s said this %s.") % [
        link_to(name, path, :class => "user"),
        content_tag( :span, shorthand(response.created_at).downcase, :class => "created-at" )  
      ]).html_safe
    else 
      super(response, format)
    end
  end
  
  
  def shares_for_topic(social=nil)
    case 
      when owner_of_topic?
        social.nil?? resource.shares : (social ? resource.shares.social : resource.shares.email)
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
      when :share then "Share This With Others!"
      when :new, :create
        case resource.form?
          when :business_recommendation then "See if Your Customers Recommend You!"
          when :recommendation then "Get Recommendations.."
          when :recommend then "Recommend a Product.."
          else "I might buy..."
        end
      when :feedback then "Get Feedback on A Product"
      else super
    end
  end
  
  def form_partial_for (topic)
    "topics/forms/%s" %
      case topic.form?
        when :business_recommendation then "business_recommendation"
        when :recommendation then "recommendation"
        when :recommend then "recommend"
        else "default"
      end    
  end
  
  def quick_links
    case action_name
      when :show
        if resource.user == current_user
          link_to("Invite Others", topic_share_path(resource), :class => "button") +
          link_for(:edit, "Update") +
          link_for(:delete, "Remove")
        else
          link_to("Invite Others", topic_share_path(resource), :class => "button")
        end
      when :share
        link_for(:back, "Go Back")
      else super
    end
  end
  
  def response_form_for (topic, &block)
    html = user_signed_in? ? {} : { "data-remote" => true }
    url    = topic_responses_path(topic, :format => user_signed_in? ? nil : :js)
    simple_form_for Response.new, :url => url, :html => html, &block
  end
  
  def open_graph_info
    if params[:feature]
      title = resource.share_title
      title = resource.subject if title.blank?
      {
        :title => title,
        :url   => request.url,
        :image => image_url(resource) { thumb('125x125#') },
        :desc  => featured_response.body
      }
    else
      case action_name
        when :show
          super.merge \
            :image => image_url(resource) { thumb('125x125#') },
            :desc  => truncate(resource.body, :length => 100)
        else super
      end
    end
  end
  
  def invited_email_address
    share ? share.with : nil
  end

end
