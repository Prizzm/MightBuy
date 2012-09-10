class TopicTag < ActiveRecord::Base
  attr_accessible :tag_id, :topic_id

  belongs_to :topic
  belongs_to :tag
end
