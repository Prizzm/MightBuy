class Card < ActiveRecord::Base
  attr_accessible :address_city, :address_country, :address_line1, :address_line1, :address_line2, :address_state, :address_zip, :address_zip_check, :country, :cvc_check, :exp_month, :exp_year, :fingerprint, :last4, :name, :card_object, :card_type, :order_id
  belongs_to :order
end
