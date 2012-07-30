class Product < ActiveRecord::Base
  has_many :bargins
  has_many :topics
  after_create :find_topics
  
  # Methods
  
  def find_topics
    t = Topic.where("url = ?", url)
    t.each do |topic|
      self.topics << topic
    end
  end
end
