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

And /^I visit profile page$/ do
  visit "I might buy"
end

Then /^I should be able to delete a topic$/ do

end

Then /^I should see all topics people are sharing$/ do
  page.should have_content(@topic.subject)
end


Then /^I should be asked to login$/ do
  current_path.should == new_user_session_path
end

Then /^I login as "(.*?)"$/ do |name|
  temp = FactoryGirl.build(:user)
  @user = User.find_by_name(name)

  page.within("#new_user") do
    fill_in("user_email", with: @user.email)
    fill_in("user_password", with: temp.password)
    page.find("input[type='submit']").click
  end
end

When /^I visit the topic path$/ do
  visit topic_path(@topic)
end

When /^I vote "(.*?)"$/ do |vote|
  lis = page.all(".topic-votes li a")
  vote == "Yes!" ? lis.first.click : lis.last.click
  wait_for_ajax_call_to_finish
end

Then /^I should be on the topic path$/ do
  current_path.should == topic_path(@topic)
end

Then /^I should see my vote as "(.*?)"$/ do |vote|
  if vote == "Yes!"
    page.should have_css("#topic-voted-yes")
    page.should_not have_css("#topic-voted-no")
  else
    page.should_not have_css("#topic-voted-yes")
    page.should have_css("#topic-voted-no")
  end
end

When /^I comment "(.*?)"$/ do |description|
  fill_in("comment_description", with: description)
  page.find(".new-comment-form-submit input").click
  wait_for_ajax_call_to_finish
end

And /^I have bunch of topics$/ do
  @user_topic = FactoryGirl.create(:topic, user: @user)
end

And /^system has topics added by other users as well$/ do
  @another_user = FactoryGirl.create(:user)
  @another_topic = FactoryGirl.create(:topic, user: @another_user)
end

When /^I visit one of my topics$/ do
  visit "/topics/#{@user_topic.shortcode}"
end

Then /^"([^"]*)" tab should be highlighted$/ do |selected_tab|
  page.find("ul.topic-tabs li.active").has_content?(selected_tab).should be_true
end

When /^I visit one of other topics$/ do
  visit "/topics/#{@another_topic.shortcode}"
end

