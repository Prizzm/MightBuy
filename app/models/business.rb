class Business < ActiveRecord::Base
  has_many :products
  
  def foreground_color
    self.forground.split(',')
  end
  
  def background_color
    self.background.split(',')
  end
end
