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
    
  scope :recommended, where(:recommend_type => 'recommend')
  scope :not_recommended, where(:recommend_type => 'not_recommended')
  scope :undecided, where(:recommend_type => 'undecided')
    
  scope :unreplied,
    where('replies.id IS NULL').where('responses.reply_id IS null').
    joins('LEFT OUTER JOIN responses as replies 
           ON replies.reply_id = responses.id')
    
  # Validations  
  validates :body, :presence => true, :unless => :recommendation?
  validates :recommend_type, :presence => true, :if => :recommendation?
    
  # Uploaders
  mount_uploader :image, ResponseImageUploader
  
  # Attributes
  attr_accessor :reply_to_email
  
  def email_address
    user ? user.email : share ? share.with : nil
  end
  
  def recommendation?
    [:recommendation, :business_recommendation].include?(topic.form?) && !reply_id?
  end
  
end