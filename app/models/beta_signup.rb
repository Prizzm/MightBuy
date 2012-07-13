class BetaSignup < ActiveRecord::Base
  
  # Scopes
  scope :recent, proc { |num| order("created_at desc").limit(num) }
  
  # Validations
  validates :email_address, :presence => true, :format => 
    { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
  
end