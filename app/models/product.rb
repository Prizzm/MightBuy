class Product < ActiveRecord::Base
  
  # Relationships
  has_many :reviews
  belongs_to :brand
  
  # Uploader
  mount_uploader :image, ProductImageUploader
  
end
