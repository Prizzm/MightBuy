module Shares
  class Share < ActiveRecord::Base
    
    # Table
    set_table_name "shares"
    
    # Relationships
    has_many :responeses
    belongs_to :topic, :inverse_of => :shares
    belongs_to :user
    
    # Scopes
    scope :with_visitor_code, proc { |code| 
      where(:visitor_code => code, :user_id => nil)  }
      
    scope :social, where(:type => [ "Shares::Recommend", "Shares::Tweet" ])
    scope :email, where(:type => "Shares::Email")
      
    # Validations
    validates :shortcode, :presence => true, :uniqueness => true
    
    
    attr_accessible :type, :with, :topic, :user, :visitor_code
    
  end
  
  class Email < Share
    validates :with, :format => 
      { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
  end
  
  class Tweet < Share
  end
  
  class Recommend < Share
  end
end


# class Shares
#   
#   include ActiveModel::Validations
#   extend ActiveModel::Naming
#   include Model::Attributes
#   include Model::Many
#   
#   many :emails, :class_name => "Share::Email"
#   
#   validates_many :emails
#   
#   def save
#     if valid?
#       
#     end
#   end
#   
#   class Email
#     
#     include ActiveModel::Validations
#     extend ActiveModel::Naming
#     include Model::Attributes
#     
#     attribute :address
#     
#     validates :address, :presence => true, 
#       :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
#     
#   end
#   
# end
