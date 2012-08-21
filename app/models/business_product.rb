class BusinessProduct < ActiveRecord::Base
  belongs_to :business
  belongs_to :product
end
