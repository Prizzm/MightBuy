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

Given /^I login as "(.*?)"$/ do |name|
  visit login_path

  temp = FactoryGirl.build(:user)
  @user = User.find_by_name(name)

  fill_in("user_email", with: @user.email)
  fill_in("user_password", with: temp.password)
  page.find("#sign-in-submit-button").click()
  page.should have_content(I18n.t "devise.sessions.signed_in")
end
