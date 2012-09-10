class Tag < ActiveRecord::Base
  attr_accessible :name

  has_many :topic_tags
  has_many :topics, :through => :topic_tags

  validate :name, presence: true
end
