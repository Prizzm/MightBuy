# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development?
  
  # File
  def tmpfile (path)
    Rails.root.join("db/seeds", path).open
  end
  
  # User
  user = User.create \
    :name => "Mitch Thompson",
    :email => "user@prizzm.com",
    :password => "password",
    :password_confirmation => "password",
    :photo => tmpfile("avatar.jpg")
  
  # Brand
  brand = Brand.create \
    :name => "Bryna", 
    :email => "brand@prizzm.com", 
    :password => "password",
    :password_confirmation => "password",
    :logo => tmpfile("logo.jpg"),
    :description => "BRYNA is a San Francisco based accessories label.
      Its handbags, which combine uptown sophistication with downtown originality, 
      are currently sold through over 150 stores and 10 websites (including 
      fashionista favorites like SHOPBOP, PIPERLIME and ENDLESS). Publications 
      including Elle, Lucky, and Daily Candy have noted BRYNA's ability to consistently 
      produce must-have bags for busy women who are on the go but refuse to 
      sacrifice style, quality, or originality.",
    :social_url => "http://www.shopbryna.com"
  
  # Products
  hermann = brand.products.create \
    :name => "Hermann Mini",
    :image => tmpfile("product.jpg")
    
end