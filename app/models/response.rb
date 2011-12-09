class Response < ActiveRecord::Base
  
  # Relationships
  has_many :replies, :class_name => "Response", :foreign_key => "reply_id"
  
  belongs_to :topic
  belongs_to :user
  belongs_to :reply, :class_name => "Response"
  belongs_to :share, :class_name => "Shares::Share"
  
  # Scopes
  scope :with_visitor_code, proc { |code| 
    where(:visitor_code => code, :user_id => nil)  }
    
  # Uploaders
  mount_uploader :image, ResponseImageUploader
  
end