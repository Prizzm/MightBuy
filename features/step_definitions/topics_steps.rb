Given /^I am logged in a user$/ do
  @user = FactoryGirl.create(:user)
  visit "/users/login"
  fill_in "user[email]", with: @user.email
  fill_in "user[password]", with: "asdfasdf"
  page.find("#sign-in-submit-button").click()
end

And /^I visit topic page$/ do
  @topic = FactoryGirl.create(:topic)
  visit "/topics"
end

Then /^I should see all topics people are sharing$/ do
  page.should have_content(@topic.subject)
end
