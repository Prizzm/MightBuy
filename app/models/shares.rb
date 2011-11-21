module Shares
  class Share < ActiveRecord::Base
    set_table_name "shares"
    belongs_to :topic
    belongs_to :user
  end
  
  class Email < Share
    validates :with, :format => 
      { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
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