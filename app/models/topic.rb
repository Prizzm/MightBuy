class Topic < ActiveRecord::Base

  # Options
  Access = {
    "Anyone." => "public",
    "Only users with shortcode." => "private"
  }
  
  # Relationships
  has_many :responses
  has_many :shares, :class_name => "Shares::Share"
  belongs_to :user
  
  # Scopes
  scope :publics, where(:access => "public")
  scope :privates, where(:access => "private")
  
  # Validations
  validates :access, :presence => { :message => "Please select one of the above :)" }
  validates :shortcode, :presence => true, :uniqueness => true
  validates :subject, :presence => true
  validates :body, :presence => true
  
  # Uploaders
  mount_uploader :image, TopicImageUploader
  
  def post?
    !question?
  end
  
  def question?
    subject[/\?\s*$/i] ? true : false
  end
  
  def to_param
    shortcode
  end
  
end