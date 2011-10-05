class Brand < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible \
    :email, :password, :password_confirmation, :remember_me, 
    :name, :logo, :social_url, :social_title, :social_desc, :social_addthis_code
  
  # Uploaders
  mount_uploader :logo, LogoUploader
  
  # Relationships
  has_many :products
  has_many :invites, :as => :inviter, :class_name => "Invites::Feedback"
  has_many :inviteds, :as => :invitee, :class_name => "Invites::Invite"
  has_many :reviews, :through => :products
  
end