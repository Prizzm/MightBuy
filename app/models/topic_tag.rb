class TopicTag < ActiveRecord::Base
  belongs_to :topic
  belongs_to :tag

  validates_presence_of :topic_id, :tag_id
end
