class Response < ActiveRecord::Base

  # Includes
  include InheritUpload
  
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
  #validates :recommend_type, :presence => true, :if => :recommendation?
    
  # Uploaders
  image_accessor :image
  
  # Attributes
  attr_accessor :reply_to_email
  
  def email_address
    user ? user.email : share ? share.with : nil
  end
  
  def recommendation?
    [:recommendation, :business_recommendation].include?(topic.form?) && !reply_id?
  end

  # interface to translate responses into votes and comments
  def create_vote!
    return nil if topic.nil? || user.nil?

    vote = Vote.create!(topic: topic, user: user, buyit: recommend_type == 'recommend')
    vote.update_attributes!(created_at: created_at, updated_at: updated_at)
    vote
  end

  def create_nested_comments!(parent = nil)
    return nil if topic.nil? || user.nil? || body.blank?

    comment = Comment.create!(topic: topic, user: user, parent: parent, description: body)
    comment.update_attributes!(created_at: created_at, updated_at: updated_at)

    replies.each { |r| r.create_nested_comments!(comment) }
    comment
  end

  def self.create_votes!
    values = ['recommend', 'not_recommended']
    Response.joins(:topic, :user).where(recommend_type: values).map(&:create_vote!)
  end

  def self.create_comments!
    Response.joins(:topic, :user).where(reply_id: nil).map(&:create_nested_comments!)
  end
end
