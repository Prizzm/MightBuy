class AntiForgeToken < ActiveRecord::Base
  belongs_to :product
  belongs_to :bargin
  belongs_to :user
  
  after_create :setup_token
  
  def setup_token
    self.update_attributes(:value => SecureRandom.hex(10), :active => true)
  end
  
  def path
    "/passbook/passes/#{self.value}"
  end
  
  def url(options = {:secure => true})
      "#{self.http_protocol(options[:secure])}://www.mightbuy.it/passbook/passes/#{self.value}"
  end
  
  def http_protocol(secure)
    if secure
      "https"
    else
      "http"
    end
  end
  
end
