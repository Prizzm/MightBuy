module SharedHelper

  def user_path (user, *args)
    user.person? ? super(user, *args) : brand_path(user, *args)
  end
  
  def image_link_for (model, url, options = {})
    style     = options.delete(:style) || :url
    image_url = image_url_for model, style
    name    = model.class.to_s.downcase
    classes = ["image", name, style, image_url ? "present" : "blank", options[:class]].compact.join(" ")
    image   = image_url ? centered { image_tag(image_url) } : ""
    
    link_to(image, url, options.merge(:class => classes))
  end
  
  def image_url_for (model, style = nil)
    uploader = case model
      when Topic then model.image
      when User then model.photo
      when Response then model.image
        # return image_url_for(model.user, style)
    end
    
    exists = !uploader.blank?
    style = style || :url
    url   = exists ? uploader.send(style) : nil
    
    unless exists
      case model
      when Topic, Response then return image_url_for(model.user, style)
      end
    end
    
    url
  end
  
  def points_tag (allocator)
    content_tag(:span, :class => "worth-points") do
      content_tag(:span, "%sP" % Points.allocators[allocator])
    end
  end
  
  def said_this (response, format = nil)
    info = user_info(response.user)
    ((format || "%s said this %s") % [
      link_to(info[:name], info[:path], :class => "user"),
      content_tag( :span, shorthand(response.created_at).downcase, :class => "created-at" )  
    ]).html_safe
  end
  
  def phrase_for (subject, object = nil)
    object ||= resource
    
    case subject
      when :header
        response = object.question? ? "%s Wants to Know.." : "%s Was Thinking.."
        response % object.user.name
      when :comments
        object.question? ? "What others think.." : "Comments.."
      when :respond
        object.question? ? "Your Feedback:" : "Have something to say?"
      when :said
        phrase = object.question? ? "%s asked this %s" : "%s said this %s"
        said_this(object, phrase)
        
    end
  end
  
  def user_info (user)
    {
      :name => user ? (user == current_user ? "You" : user.name) : "Guest",
      :path => user ? user_path(user) : "#guest",
      :thumb => user ? (user.photo.blank? ? user.photo.thumb : nil) : nil
    }
  end
  
end