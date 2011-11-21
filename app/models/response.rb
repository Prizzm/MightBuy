class Response < ActiveRecord::Base
  
  # Relationships
  belongs_to :topic
  belongs_to :user
  
end