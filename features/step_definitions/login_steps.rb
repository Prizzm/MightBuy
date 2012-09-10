Given /^a confirmed user "(.*?)"$/ do |name|
  @user = FactoryGirl.create(:user, name: name)
end

Given /^a confirmed user "(.*?)" with a topic$/ do |name|
  step %Q{a confirmed user "#{name}"}
  @topic = FactoryGirl.create(:topic, user: @user)
end
