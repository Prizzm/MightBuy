module SharedHelper
  
  def image_link_for (model, url, options = {})
    uploader = case model
      when Topic then model.image
      when User then model.photo
      when Response then return image_link_for(model.user, url, options)
    end

    exists = !uploader.blank?
    style = options.delete(:style) || :url
    name  = exists ? model.class.to_s.downcase : nil
    image = exists ? centered { image_tag(uploader.send(style)) } : nil
    classes = ["image", name, style, exists ? "present" : "blank", options[:class]].compact.join(" ")
    
    unless exists
      case model
        when Topic
          return image_link_for(model.user, url, options.merge(:style => style))
      end
    end
    
    link_to(image || "", url, options.merge(:class => classes))
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
        object.question? ? "What's your two cents?" : "Have something to say?"
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