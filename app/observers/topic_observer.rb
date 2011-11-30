class TopicObserver < ActiveRecord::Observer
  
  def before_validation (topic)
    topic.shortcode ||= Shortcode.new
  end
  
  def after_create (topic)
    if topic.user
      topic.user.points.add :starting_a_topic, :allocatable => topic
    end
  end
  
end