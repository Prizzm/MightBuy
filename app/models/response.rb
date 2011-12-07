class Response < ActiveRecord::Base
  
  # Relationships
  belongs_to :topic
  belongs_to :user
  belongs_to :share
  belongs_to :share, :class_name => "Shares::Share"
  
  # Scopes
  scope :with_visitor_code, proc { |code| 
    where(:visitor_code => code, :user_id => nil)  }
    
  # Uploaders
  mount_uploader :image, ResponseImageUploader
  
end