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
  
  # Brand
  brand = Brand.create \
    :name => "Bryna", 
    :email => "demo@prizzm.com", 
    :password => "asdfasdf",
    :password_confirmation => "asdfasdf",
    :logo => tmpfile("logo.jpg")
  
  # Products
  hermann = brand.products.create \
    :name => "Hermann Mini",
    :image => tmpfile("product.jpg")
    
end