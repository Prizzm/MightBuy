module Invites
  
  class Invite < ActiveRecord::Base
    
    # Relationships
    belongs_to :inviter, :polymorphic => true
    belongs_to :invitee, :polymorphic => true
    belongs_to :reference, :polymorphic => true
    
    # Validations
    validates :inviter, :presence => true
    validates :invitee, :presence => true
    validates :code, :presence => true
    
  end
  
  class Feedback < Invite
    
    # Validations
    validates :email, :presence => true
    validates :product_id, :presence => true
    
    # Methods
    
    def email
      invitee.email if invitee
    end
    
    def email= (value)
      self.invitee = User.find_or_initialize_by_email(value)
    end
    
    def product_id
      reference.id if reference
    end
    
    def product_id= (value)
      self.reference = Product.find_by_id(value)
    end
    
    def product
      reference
    end
    
    def product= (value)
      self.reference = value
    end
    
  end
  
end