class Product < ActiveRecord::Base
  # has_many :business_products
  # has_many :businesses, :through => :business_products
  belongs_to :business

  has_many :bargins
  has_many :topics
  has_many :anti_forge_tokens
  after_create :find_topics

  # Methods

  def find_topics
    t = Topic.where("url = ?", url)
    t.each do |topic|
      self.topics << topic
    end
  end

  def self.busiest_products(count = 20)
    Topic.group(:product_id).
      select("count(product_id) as product_count,product_id").
      limit(count).
      order("product_count desc").map(&:product)
  end
end
