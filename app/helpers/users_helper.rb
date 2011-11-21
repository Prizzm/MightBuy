module UsersHelper

  def header
    case action_name
      when :index then "Our Beloved Users.."
      when :show then "%s's Profile" % resource.name
      else super
    end
  end
  
  def quick_links
  end
  
  def last_active (user)
    ("%s was last active %s" % [
      link_to(user.name, user_path(user), :class => "user"),
      shorthand(user.updated_at).downcase
    ]).html_safe
  end
  
end