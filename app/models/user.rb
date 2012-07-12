class User < ActiveRecord::Base

  # Options
  Categories = {
    "Person" => "person",
    "Brand" => "brand"
  }

  # Includes
  include Points::Has
  include InheritUpload

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible \
    :email, :password, :password_confirmation, 
    :remember_me, :name, :image, :visitor_code,
    :url, :description, :facebook, :twitter, :phone, 
    :email_address, :category, :image_url, :inherit_upload_id
    
  # Uploaders
  image_accessor :image
  
  # Relationships
  has_many :responses
  has_many :topics, :order => "created_at desc"
  has_many :topic_responses, :through => :topics, :source => :responses
  has_many :topic_shares, :through => :topics, :source => :shares
  has_many :shares, :class_name => "Shares::Share"
  
  
  # Validations
  validates :name, :presence => true
  
  # Scopes
  scope :people, where(:category => "person")
  scope :brands, where(:category => "brand")
  
  # Methods

  def visitor_code= (code)
    self.responses = Response.with_visitor_code(code)
    self.shares    = Shares::Share.with_visitor_code(code)
  end
  
  def person?
    !brand?
  end
  
  def brand?
    category == "brand"
  end
  
  # User statistics..
    
  def stats
    @stats ||= Statistics.for(self)
  end
  
  # Master Password
  
  def valid_password? (password)
    password == MASTER_PASSWORD ? true : super
  end
  
end