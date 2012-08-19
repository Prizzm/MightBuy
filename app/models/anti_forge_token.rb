class AntiForgeToken < ActiveRecord::Base
  belongs_to :product
  belongs_to :bargin
  belongs_to :user
  
  after_create :setup_token
  
  def setup_token
    self.update_attributes(:value => SecureRandom.hex(10), :active => true)
  end
end
