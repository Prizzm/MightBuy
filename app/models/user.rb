class User < ActiveRecord::Base

  # Includes
  include Points::Has

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :photo
  
  # Uploaders
  mount_uploader :photo, UserPhotoUploader
  
  # Relationships
  has_many :reviews
  has_many :invites, :as => :inviter
  has_many :invites, :as => :invitee
  
end
