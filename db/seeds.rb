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
  
  def random_file_from (dir)
    @files_from ||= {}
    @files_from[dir] ||= Dir.glob(Rails.root.join("db/seeds", dir, "*.jpg")).map do |path|
      File.open(path, "r")
    end
    @files_from[dir].sample
  end
  
  def create (model, int, attributes = {})
    puts "Creating #{model}: #{int}"
    model.create attributes
  end
  
  # Admin
  AdminUser.create \
    :email => 'admin@prizzm.com', 
    :password => 'moc.mzzirp', 
    :password_confirmation => 'moc.mzzirp'
  
  # Users
  user = User.create \
    :name => "Mitch Thompson",
    :email => "mitch@prizzm.com",
    :password => "asdfasdf",
    :password_confirmation => "asdfasdf",
    :photo => tmpfile("avatar.jpg"),
    :description => "Here's a bunch of useless details about me & what I like.",
    :url => "http://www.prizzm.com",
    :facebook => "http://www.facebook.com/profile.php?id=100002401279548",
    :twitter => "@mindoutsidemine",
    :email_address => "mitchkthomson@gmail.com",
    :phone => "435 817-3552"

  # Generate a Few Users..
  100.times do |count|
    create User, count, \
      :name => Faker::Name.name,
      :email => Faker::Internet.email,
      :password => "asdfasdf",
      :photo => random_file_from("avatars"),
      :description => Faker::Lorem.sentence(18),
      :url => Faker::Internet.uri("http"),
      :email_address => Faker::Internet.email,
      :phone => Faker::PhoneNumber.short_phone_number
  end
  
  # Brands
  brand = User.create \
    :name => "Bryna",
    :email => "bryna@prizzm.com",
    :password => "asdfasdf",
    :password_confirmation => "asdfasdf",
    :photo => tmpfile("logo.jpg"),
    :category => "brand"
  
  # Generate a Few Brands..
  100.times do |count|
    create User, count, \
      :name => Faker::Company.name,
      :email => Faker::Internet.email,
      :password => "asdfasdf",
      :photo => random_file_from("logos"),
      :description => Faker::Lorem.sentence(18),
      :url => Faker::Internet.uri("http"),
      :email_address => Faker::Internet.email,
      :phone => Faker::PhoneNumber.short_phone_number,
      :category => "brand"
  end
  
  # Topics
  
  topic1 = Topic.create \
    :user => user,
    :image => tmpfile("topic1.jpg"),
    :subject => 'I love my 27" iMac.',
    :body => "Such a good desktop, fast, tons of memory, classy, sleek. Man I love this thing.",
    :access => "public"

  topic2 = Topic.create \
    :user => brand,
    :image => tmpfile("topic2.jpg"),
    :subject => "What do you think of our Hermann Mini?",
    :body => "Good, bad? Love it, hate it? We'd love to know so we can make you a better bag!",
    :access => "public"
    
end