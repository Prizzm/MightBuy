class Response < ActiveRecord::Base
  
  # Relationships
  belongs_to :topic
  belongs_to :user
  
  # Scopes
  scope :with_visitor_code, proc { |code| 
    where(:visitor_code => code, :user_id => nil)  }
    
  # Uploaders
  mount_uploader :image, ResponseImageUploader
  
end