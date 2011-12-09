module UsersHelper

  def header
    case action_name
      when :index then "Our Beloved Users.."
      when :show then "%s's Profile" % resource.name
      else super
    end
  end
  
  def quick_links
    if action_name == :show
      links = connect_links
      ("<span>Get in Touch..</span> %s" % links).html_safe unless links.blank?
    end
  end
  
  def connect_links
    resource.attributes.map do |attr, value|
      unless value.blank?
        case attr.to_sym
          when :facebook then icon_link "facebook.png", value
          when :twitter then icon_link "twitter.png", value
          when :email_address then icon_link "email.png", "mailto:#{value}"
        end
      end
    end.compact.join("\n")
  end
  
  def icon_link (path, url)
    link_to image_tag("/images/icons/%s" % path), url, :class => "icon", :target => "_blank"
  end
  
  def last_active (user)
    ("%s was last active %s" % [
      link_to(user.name, user_path(user), :class => "user"),
      shorthand(user.updated_at).downcase
    ]).html_safe
  end
  
  def phrase_for (subject, object = nil)
    object ||= resource

    case subject
      when :url then object.brand? ? "Visit Us:" : "Visit Me"
      when :phone then object.brand? ? "Call Us" : "Call Me"
      when :posts
        (object.brand? ? "The latest from %s.." : "What's on %s's mind?") % resource.name
      when :activity
        "%s's Latest Activity.." % resource.name
      when :no_description
        (object.brand? ? "%s hasn't described what they do yet." : 
                         "I haven't said anything about myself yet :)") % resource.name
          
      else super
    end
  end
  
end