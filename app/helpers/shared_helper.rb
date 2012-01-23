module SharedHelper

  include SocialHelper
  include ResponsesHelper
  
  def title (heading = nil)
    heading ? "%s | Prizzm" % heading : "Prizzm | Rewarding Feedback"
  end

  def to_link (string)
    url = string.gsub /^(http(s)?\:\/\/)?/, 'http\2://'
    link_to url, url, :target => "_blank"
  end

  def user_path (user, *args)
    user.person? ? super(user, *args) : brand_path(user, *args)
  end
  
  def override (id, &block)
    content = content_for(id)
    content.blank? ? (block_given? ? capture(&block) : "") : content
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
    
    url = URI.join(root_url, url.to_s).to_s if url && Rails.env.development?
    
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
    ((format || "%s said this %s.") % [
      link_to(info[:name], info[:path], :class => "user"),
      content_tag( :span, shorthand(response.created_at).downcase, :class => "created-at" )  
    ]).html_safe
  end
  
  def said_this_in_response (response)
    format = resource.is_a?(Topic) ? 
      "%1$s said this %4$s." : "In response to %2$s by %3$s %4$s."
      
    info = user_info(response.user)
    user_link       = link_to info[:name], info[:path], :class => "user"
    topic_link      = link_to response.topic.subject, topic_path(response.topic), :class => "topic"
    topic_user_link = link_to response.topic.user.name, user_path(response.topic.user), :class => "topic-user"
    created_at      = content_tag :span, shorthand(response.created_at).downcase, :class => "created-at"
    
    (format % [user_link, topic_link, topic_user_link, created_at]).html_safe
  end
  
  def phrase_for (subject, object = nil)
    object ||= resource
    
    case subject
      when :header
        response = case
          when object.question? then "%s Wants to Know.."
          when object.form == "recommend" then "%s Recommended.."
          else "%s Was Thinking.."
        end
        
        # response = object.question? ? "%s Wants to Know.." : "%s Was Thinking.."
        response % object.user.name
      when :comments
        object.question? ? "What others think.." : "Comments.."
      when :respond
        object.question? ? "Your Feedback.." : "Have something to say?"
      when :said
        phrase = object.question? ? "%s asked this %s." : "%s said this %s."
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
  
  # Placeholders
  
  def placeholder (collection, &block)
    type = collection.name.downcase.pluralize.gsub("::", "_")
    name = [ params[:controller], params[:action], type ] * "_"
    
    if collection.empty?
      content_tag :div, :class => "placeholder" do
        render("placeholder", :type => type.to_sym, :name => name.to_sym)
      end
    else
      capture(collection, &block)
    end
  end
  
  def image_url (path)
    URI.join(root_url, image_path(path))
  end
  
  def points_flash (message)
    content_tag :div, :class => "points" do
      content_tag( :div, '*Cha-Ching!*', :class => "onomatopoeia" ) +
      content_tag( :div, message.html_safe, :class => "bar" )
    end
  end
  
end