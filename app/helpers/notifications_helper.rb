module NotificationsHelper

  include SharedHelper
  
  def url (path)
    URI::join(root_url, path.to_s)
  end
  
  def table (*classes, &block)
    classes = classes.join(" ")
    content_tag :table, :class => classes do
      content_tag :tr do
        content_tag(:td, :class => classes, &block)
      end
    end
  end
  
  def lines (&block)
    simple_format(capture(&block)).html_safe
  end
  
  def reply_text
    @topic.question? ? "Give Your Answer!" : "Should I buy them?"
  end
  
  def sent_to_by
    ("This email was sent to %s by %s" % 
      [ mail_to(@to_email), @name ]).html_safe
  end
  
end