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
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible \
    :email, :password, :password_confirmation, 
    :remember_me, :name, :image, :visitor_code,
    :url, :description, :facebook, :twitter, :phone, 
    :email_address, :category, :image_url, :inherit_upload_id, :authentication_token, :facebook_uid, :twitter_uid
    
  # Uploaders
  image_accessor :image
  
  # Relationships
  has_many :responses
  has_many :topics, :order => "created_at desc"
  has_many :topic_responses, :through => :topics, :source => :responses
  has_many :topic_shares, :through => :topics, :source => :shares
  has_many :shares, :class_name => "Shares::Share"
  has_many :auth_providers
  
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
  
  # Omniauth
  def self.from_omniauth(auth)
    if User.find_by_facebook_uid(auth.uid) == nil && User.find_by_twitter_uid(auth.uid) == nil then
      puts "no uid"
      u = User.new()
      u.name = auth.info.name
      app = Dragonfly[:images]
      u.image = app.fetch_url(auth.info.image)
      if auth.provider == "twitter" then
        u.twitter_uid = auth.uid
        u.twitter_oauth_token = auth['credentials']['token']
        u.twitter_oauth_secret = auth['credentials']['secret']
      elsif auth.provider == "facebook" then
        u.facebook_uid = auth.uid
        u.email = auth.info.email
        u.facebook = auth.urls.Facebook
        u.facebook_oauth_token = auth['credentials']['token']
        u.facebook_oauth_secret = auth['credentials']['secret']
      end
      u.save
      return u
    else
      puts "uid"
      if User.find_by_facebook_uid(auth.uid) == nil then
        return User.find_by_twitter_uid(auth.uid)
      elsif User.find_by_twitter_uid(auth.uid) == nil then
        return User.find_by_facebook_uid(auth.uid)
      end
      return AuthProvider.find_by_uid(auth.uid).user
    end
    # where(auth.slice(:provider, :uid)).first_or_create do |user|
    #   user.provider = auth.provider
    #   user.uid = auth.uid
    #   user.username = auth.info.nickname
    # end
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    if self.facebook_uid || self.twitter_uid then
      return false
    else
      return true
    end
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end
  
end