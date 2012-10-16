class Fee < ActiveRecord::Base
  attr_accessible :amount, :application, :currency, :description, :fee_type
  belongs_to :order
end
