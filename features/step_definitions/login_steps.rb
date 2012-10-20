Given /^a confirmed user "(.*?)"$/ do |name|
  @user = FactoryGirl.create(:user, name: name)
end

Given /^a confirmed user "(.*?)" with a topic$/ do |name|
  step %Q{a confirmed user "#{name}"}
  @topic = FactoryGirl.create(:topic, user: @user)
  @mightbuy_topic = @topic
end

Given /^a confirmed user "(.*?)" with a have topic$/ do |name|
  step %Q{a confirmed user "#{name}"}
  @topic = FactoryGirl.create(:topic, user: @user, status: "ihave")
  @have_topic = @topic
end

Then /^I should be asked to login via lightbox$/ do
  page.has_css?("#login-lightbox").should be_true
end

def signin_user(user)
  temp = FactoryGirl.build(:user)

  visit login_path
  fill_in "user[email]", with: @user.email
  fill_in "user[password]", with: temp.password
  page.find("#sign-in-submit-button").click()
  page.should have_content(I18n.t "devise.sessions.signed_in")
end

Given /^I am logged in a user$/ do
  @user = FactoryGirl.create(:user)
  signin_user(@user)
end


Then /^I login as "(.*?)"$/ do |name|
  @user = User.find_by_name(name)
  signin_user(@user)
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

Given /^I visit my profile$/ do
  visit user_path(@user)
end

Then /^I visit profile of "(.*?)"$/ do |name|
  user = User.find_by_name(name)
  visit user_path(user)
end

Given /^I delete my profile$/ do
  click_link("Edit Profile")
  click_link("Delete Account")
  page.should have_content("Bye! Your account was successfully cancelled. We hope to see you again soon.")
end
