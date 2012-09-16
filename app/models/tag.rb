class Tag < ActiveRecord::Base
  attr_accessible :name

  has_many :topic_tags
  has_many :topics, :through => :topic_tags

  validates_presence_of :name

  validates_uniqueness_of :name

  def self.popular_tags
    Tag.joins{topic_tags}.select{count(topic_tags.tag_id).as('tag_count')}.
      select{"tags.*"}.group{topic_tags.tag_id}.order("tag_count desc").limit(20)
  end
end
