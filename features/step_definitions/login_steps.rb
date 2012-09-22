Given /^a confirmed user "(.*?)"$/ do |name|
  @user = FactoryGirl.create(:user, name: name)
end

Given /^a confirmed user "(.*?)" with a topic$/ do |name|
  step %Q{a confirmed user "#{name}"}
  @topic = FactoryGirl.create(:topic, user: @user)
end

Then /^I should be asked to login via lightbox$/ do
  page.has_css?("#login-lightbox").should be_true
end

Then /^I login as "(.*?)" via lightbox$/ do |name|
  temp = FactoryGirl.build(:user)
  @user = User.find_by_name(name)

  page.within("#signin_user") do
    fill_in("user_email", with: @user.email)
    fill_in("user_password", with: temp.password)
    click_button "Sign in!"
  end
end
