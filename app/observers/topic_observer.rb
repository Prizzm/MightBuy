class TopicObserver < ActiveRecord::Observer
  
  def before_validation (topic)
    topic.shortcode ||= Shortcode.new
  end
  
  def before_create (topic)

    # Topic Forms..
    case topic.form.to_s.to_sym
      when :recommendation
        product = topic.subject
        topic.subject = "Would you recommend your %s?" % product
        topic.body = "%s would like to know if you would recommend your %s to your friends!" % [ topic.user.name, product ]
        topic.share_title = "I recommend %s by %s!" % [ product, topic.user.name ]
      when :recommend
        topic.body = "I recommend you check out %s!" % topic.subject
    end
    
  end
  
  def after_create (topic)
    if topic.user
      topic.user.points.add :starting_a_topic, :allocatable => topic
    end
  end
  
end