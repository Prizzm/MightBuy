class Bargin < ActiveRecord::Base
  belongs_to :product
  has_many :anti_forge_tokens
end
