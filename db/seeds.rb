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
  
  # Users
  user1 = User.create \
    :name => "Mitch Thompson",
    :email => "mitch@prizzm.com",
    :password => "asdfasdf",
    :password_confirmation => "asdfasdf",
    :photo => tmpfile("avatar1.jpg"),
    :description => "Here's a bunch of useless details about me & what I like.",
    :url => "http://www.prizzm.com",
    :facebook => "http://www.facebook.com/profile.php?id=100002401279548",
    :twitter => "http://www.twitter.com",
    :email_address => "mitchkthomson@gmail.com",
    :phone => "435 817-3552"
    
  user2 = User.create \
    :name => "Bryna",
    :email => "bryna@prizzm.com",
    :password => "asdfasdf",
    :password_confirmation => "asdfasdf",
    :photo => tmpfile("avatar2.jpg"),
    :category => "brand"
  
  # Topics
  
  topic1 = Topic.create \
    :user => user1,
    :image => tmpfile("topic1.jpg"),
    :subject => 'I love my 27" iMac.',
    :body => "Such a good desktop, fast, tons of memory, classy, sleek. Man I love this thing.",
    :access => "public"

  topic2 = Topic.create \
    :user => user2,
    :image => tmpfile("topic2.jpg"),
    :subject => "What do you think of our Hermann Mini?",
    :body => "Good, bad? Love it, hate it? We'd love to know so we can make you a better bag!",
    :access => "public"
    
end