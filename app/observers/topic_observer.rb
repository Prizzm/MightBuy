class TopicObserver < ActiveRecord::Observer
  
  def before_validation (topic)
    topic.shortcode ||= Shortcode.new
  end
  
end