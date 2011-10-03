class Review < ActiveRecord::Base
  
  # Relationships
  belongs_to :product
  belongs_to :user
  
end