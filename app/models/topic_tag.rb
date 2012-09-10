class TopicTag < ActiveRecord::Base
  attr_accessible :tag_id, :topic_id

  belongs_to :topic
  belongs_to :tag

  validate :topic_id, :tag_id, presence: true
end
