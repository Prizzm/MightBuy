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
  page.should have_content(I18n.t("voting.success"))

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

Then /^I should see my comment as "(.*?)"$/ do |comment|
  page.should have_content(I18n.t("commenting.success"))
  page.should have_content(comment)
end

And /^I have bunch of topics$/ do
  @user_topic = FactoryGirl.create(:topic, user: @user)
end

And /^system has topics added by other users as well$/ do
  @another_user = FactoryGirl.create(:user)
  @another_topic = FactoryGirl.create(:topic, user: @another_user)
end

When /^I visit one of my topics$/ do
  visit topic_path(@user_topic.shortcode)
end

Then /^"([^\"]*)" tab should be highlighted$/ do |selected_tab|
  page.find("ul.topic-tabs li.active").has_content?(selected_tab).should be_true
end

When /^I visit one of other topics$/ do
  visit "/topics/#{@another_topic.shortcode}"
end

Given /^I create a topic by filling the form$/ do
  topic = FactoryGirl.build(:topic)
  fill_in("topic_subject", with: topic.subject)
  fill_in("topic_price", with: topic.price)
  fill_in("topic_body", with: topic.body)
  click_button("Save")
  page.should have_content(topic.subject)

  @topic = Topic.first
  @topic.should_not be_nil
end


def tab_has_topic?(tab, topic)
  click_link(tab)
  page.has_content?(topic.subject)
end

Then /^I should see the topic in mightbuy$/ do
  tab_has_topic?("I might buy", @topic).should be_true
end

Then /^I should not see the topic in mightbuy$/ do
  tab_has_topic?("I might buy", @topic).should be_false
end

Then /^I should see the topic in have$/ do
  tab_has_topic?("I Have", @topic).should be_true
end

Then /^I should not see the topic in have$/ do
  tab_has_topic?("I Have", @topic).should be_false
end


Then /^I mark the topic as i have$/ do
  page.within("#ihave_edit_topic") do
    check("ihave")
    wait_for_ajax_call_to_finish
  end
  page.should have_content("Topic Updated")
end

Then /^I mark the topic as i dont have$/ do
  page.within("#ihave_edit_topic") do
    uncheck("ihave")
    wait_for_ajax_call_to_finish
  end
  page.should have_content("Topic Updated")
end
