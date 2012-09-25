class Tag < ActiveRecord::Base
  attr_accessible :name

  has_many :topic_tags
  has_many :topics, :through => :topic_tags

  validates_presence_of :name

  validates_uniqueness_of :name

  def self.popular_tags
    Tag.select("tags.*, c.tag_count").joins("JOIN (select topic_tags.tag_id, count(*) as tag_count from topic_tags group by tag_id) c on tags.id = c.tag_id").limit(15)
  end

  def to_param
    name
  end
end
