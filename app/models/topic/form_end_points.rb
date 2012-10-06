module Topic::FormEndPoints
  extend ActiveSupport::Concern

  module ClassMethods
    def build_from_form_data(topic_details,current_user,visitor_code)
      if topic_details['image_url']
        topic_details['image_url'] = URI.parse(URI.encode(topic_details['image_url']).gsub("[","%5B").gsub("]","%5D")).to_s
      end
      if topic_details['tags']
        tag_string = topic_details.delete('tags')
      end

      topic = Topic.new(topic_details)
      topic.access = 'public'
      topic.user = current_user
      topic.pass_visitor_code = visitor_code
      if topic_details["mobile_image_url"]
        dragon = Dragonfly[:images]
        topic.image = dragon.fetch_url(topic_details["mobile_image_url"])
      end
      topic.add_tags(tag_string)
      topic
    end

    def except_user_topics(page_number,current_user = nil)
      topic_scope = current_user ? Topic.where("user_id != ?",current_user.id) : Topic
      topic_scope.order("created_at desc").page(page_number).per(10)
    end
  end

  def update_from_form_data(topic_details,visitor_code)
    if topic_details['image_url'] && URI.parse(URI.encode(topic_details['image_url'])).host
      topic_details['image_url'] = URI.parse(URI.encode(topic_details['image_url']).gsub("[","%5B").gsub("]","%5D")).to_s
    else
      topic_details.delete('image_url')
    end
    tag_string = topic_details.delete('tags') || []
    self.pass_visitor_code = visitor_code
    self.add_tags(tag_string)
    self.update_attributes(topic_details)
  end
end
