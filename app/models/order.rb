class Order < ActiveRecord::Base
  attr_accessible :amount, :amount_refunded, :card_id, :created_stripe, :currency, :customer, :description, :disputed, :failure_message, :fee, :fee_id, :invoice, :invoice_id, :livemode, :object, :paid, :product_id, :refunded, :topic_id, :user_id, :fulfilled
  has_one :card
  belongs_to :user
  belongs_to :product
  belongs_to :topic
  has_many :fees
end
