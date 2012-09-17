module Shares
  class Share < ActiveRecord::Base
    
    # Table
    self.table_name ="shares"
    
    # Relationships
    has_many :responeses
    belongs_to :topic, :inverse_of => :shares
    belongs_to :user
    
    # Scopes
    scope :with_visitor_code, proc { |code| 
      where(:visitor_code => code, :user_id => nil)  }
      
    scope :social, where(:type => [ "Shares::Recommend", "Shares::Tweet" ])
    scope :email, where(:type => "Shares::Email")
    scope :tweets, where(type: "Shares::Tweet")
    scope :recommends, where(type: "Shares::Recommend")
      
    # Validations
    validates :shortcode, :presence => true, :uniqueness => true
    
    
    attr_accessible :type, :with, :topic, :user, :visitor_code, :mobile_image_url
    
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
