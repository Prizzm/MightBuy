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
    
  # Validations  
  validates :body, :presence => true, :unless => :recommendation?
  validates :recommend_type, :presence => true, :if => :recommendation?
    
  # Uploaders
  mount_uploader :image, ResponseImageUploader
  
  # Methods
  
  def recommendation?
    topic.form.to_s.to_sym == :recommendation && !reply_id?
  end
  
end