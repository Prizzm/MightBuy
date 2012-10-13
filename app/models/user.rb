class User < ActiveRecord::Base

  # Options
  Categories = {
    "Person" => "person",
    "Brand" => "brand"
  }

  # Includes
  include Points::Has
  include InheritUpload
  extend FriendlyId

  friendly_id :name, use: :slugged

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable, :omniauthable

  # Uploaders
  image_accessor :image

  attr_accessible \
    :email, :password, :password_confirmation,
    :remember_me, :name, :image, :visitor_code,
    :url, :description, :facebook, :twitter, :phone,
    :email_address, :category, :image_url, :inherit_upload_id, :authentication_token, :facebook_uid, :twitter_uid, :last_seen


  # Relationships
  has_many :responses
  has_many :topics, :order => "created_at desc"
  has_many :topic_responses, :through => :topics, :source => :responses
  has_many :topic_shares, :through => :topics, :source => :shares
  has_many :shares, :class_name => "Shares::Share"
  has_many :auth_providers
  has_many :antiForgeTokens

  has_many :deals, :class_name => "Deals::Deal"

  # Validations
  validates :name, :presence => true

  # Scopes
  scope :people, where(:category => "person")
  scope :brands, where(:category => "brand")

  has_many :timeline_events, :as => :actor

  # Methods

  def hasTwitter?
    twitter_uid && twitter_oauth_token && twitter_oauth_secret
  end

  def haves
    topics.have
  end

  def hasFacebook?
    facebook_uid && facebook_oauth_token
  end

  def visitor_code= (code)
    self.responses = Response.with_visitor_code(code)
    self.shares = Shares::Share.with_visitor_code(code)
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
    user = nil
    unless User.find_with_auth_id(auth.uid)
      user = User.new()
      user.name = auth.info.name
      user.image_url = auth.info.image
      if auth.provider == "twitter"
        user.twitter_uid = auth.uid
        user.twitter_oauth_token = auth['credentials']['token']
        user.twitter_oauth_secret = auth['credentials']['secret']
      elsif auth.provider == "facebook"
        user.facebook_uid = auth.uid
        user.email = auth.info.email
        user.facebook_oauth_token = auth['credentials']['token']
        user.facebook_oauth_secret = auth['credentials']['secret']
      end
      user.save
    else
      user = User.find_with_auth_id(auth.uid)
      if auth.provider == "twitter"
        user.twitter_uid = auth.uid
        user.twitter_oauth_token = auth['credentials']['token']
        user.twitter_oauth_secret = auth['credentials']['secret']
      elsif auth.provider == "facebook"
        user.facebook_uid = auth.uid
        user.facebook_oauth_token = auth['credentials']['token']
        user.facebook_oauth_secret = auth['credentials']['secret']
      end
      user.image_url = auth.info.image
      user.save
    end
    user
  end

  def self.find_with_auth_id(auth_id)
    User.find_by_facebook_uid(auth_id) || User.find_by_twitter_uid(auth_id)
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        h = Hash.new
        if params[:name] then
          h[:name] = params[:name]
          # user.attributes.name = params[:name]
        end
        if params[:email] then
          h[:email] = params[:email]
          # user.attributes.email = params[:email]
        end
        if params[:facebook_uid] then
          h[:facebook_uid] = params[:facebook_uid]
          # user.attributes.facebook_uid = params[:facebook_uid]
        end
        if params[:twitter_uid] then
          h[:twitter_uid] = params[:twitter_uid]
          # user.attributes.twitter_uid = params[:twitter_uid]
        end
        if params[:facebook_oauth_token] then
          h[:facebook_oauth_token] = params[:facebook_oauth_token]
          # user.attributes.facebook_oauth_token = params[:facebook_oauth_token]
        end
        if params[:twitter_oauth_token] then
          h[:twitter_oauth_token] = params[:twitter_oauth_token]
          # user.attributes.twitter_oauth_token = params[:twitter_oauth_token]
        end
        if params[:twitter_oauth_secret] then
          h[:twitter_oauth_secret] = params[:twitter_oauth_secret]
          # user.attributes.twitter_oauth_secret = params[:twitter_oauth_secret]
        end
        user.attributes = h
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    if self.facebook_uid || self.twitter_uid then
      return false
    elsif self.new_record?
      return true
    else
      return false
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
