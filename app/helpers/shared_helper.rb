module SharedHelper

  include SocialHelper
  include ResponsesHelper
  
  def title (heading = nil)
    heading ? "%s | MightBuy" % heading : "MightBuy | Track stuff you might buy"
  end

  def user_path (user, *args)
    if user
      user.person? ? super(user, *args) : brand_path(user, *args)
    else
      "javascript:void(0);"
    end
  end
  
  def override (id, &block)
    content = content_for(id)
    content.blank? ? (block_given? ? capture(&block) : "") : content
  end
  
  def image_link (model, url, options = {}, &block)
    image_url = image_url(model, &block)
    name    = model.class.to_s.downcase
    classes = ["image", name, image_url ? "present" : "blank", options[:class]].compact.join(" ")
    image   = image_url ? centered { image_tag(image_url) } : ""

    link_to(image, url, options.merge(:class => classes))
  end
  
  def image_url (model, &block)
    image = case model
      when Topic then model.image
      when User then model.image
      when Response then model.image
    end
    
    exists = !image.blank?
    block  = block_given? ? block : proc { self }
    url    = exists ? image.instance_eval(&block).url : nil
    
    url = absolute_url(url.to_s) if url && Rails.env.development?
    
    unless exists
      case model
        when Topic, Response then return image_url(model.user, &block)
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

  def said_this_in_response (response, is_feedback=false)
    format = resource.is_a?(Topic) ?
      "%1$s said this %4$s." : "%1$s said this in response to %2$s by %3$s %4$s."

    info = user_info(response.user)

    # If this is a feedback's response and user is Guest, show the user's email.
    is_feedback && info[:name] == "Guest" && info[:name] = response.email_address

    user_link       = link_to info[:name], info[:path], :class => "user"
    topic_link      = link_to shorthand(response.topic.subject), topic_path(response.topic), :class => "topic"
    topic_user_link = link_to shorthand(response.topic.user.name), user_path(response.topic.user), :class => "topic-user"
    created_at      = content_tag :span, shorthand(response.created_at).downcase, :class => "created-at"

    (format % [user_link, topic_link, topic_user_link, created_at]).html_safe
  end

  def phrase_for (subject, object = nil)
    object ||= resource
    
    case subject
      when :header
        response = case
          when object.question? then "%s is asking for feedback.."
          when object.form == "recommend" then "%s Recommended.."
          else "%s might buy.."
        end
        
        # response = object.question? ? "%s Wants to Know.." : "%s Was Thinking.."
        response % object.user.name
      when :comments
        object.question? ? "What others think.." : "Comments.."
      when :respond
        object.question? ? "Comments.." : "Comments.."
      when :said
        phrase = object.question? ? "%s asked this %s." : "%s said this %s."
        said_this(object, phrase)
        
    end
  end
  
  def user_info (user)
    {
      :name => user ? (user == current_user ? "You" : user.name) : "Guest",
      :path => user ? user_path(user) : "#guest",
      :thumb => user ? (user.image.blank? ? nil : user.image.thumb) : nil
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
  
  def absolute_url (path)
    URI.join(root_url, image_path(path)).to_s
  end
  
  def formatted_url (url)
    url[/^https?:\/\//] ? "#{url}" : "http://#{url}"
  end
  
  def points_flash (message)
    content_tag :div, :class => "points" do
#      content_tag( :div, '*Cha-Ching!*', :class => "onomatopoeia" ) +
      content_tag( :div, message.html_safe, :class => "bar" )
    end
  end
  
end
