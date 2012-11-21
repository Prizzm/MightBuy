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
  page.find(".new_comment input[type=submit]").click
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

Given /^I create a have topic by filling the form$/ do
  topic = FactoryGirl.build(:topic)
  fill_in("topic_subject", with: topic.subject)
  fill_in("topic_body", with: "Cool Review")
  click_button("Save")
  page.should have_content(topic.subject)

  @topic = Topic.first
  @topic.should_not be_nil
  @have_topic = @topic
end


def tab_has_topic?(tab, topic)
  click_link(tab)
  page.has_content?(topic.subject)
end

Then /^I should see the topic in mightbuy$/ do
  tab_has_topic?("I MightBuy", @topic).should be_true
end

Then /^I should not see the topic in mightbuy$/ do
  tab_has_topic?("I MightBuy", @topic).should be_false
end

Then /^I should see the topic in have$/ do
  tab_has_topic?("I Have", @topic).should be_true
end

Then /^I should not see the topic in have$/ do
  tab_has_topic?("I Have", @topic).should be_false
end

Given /^I buy the topic$/ do
  click_link "Add to have"
  fill_in("topic_body", with: "Cool Review")
  click_button("Save")

  page.should have_content(@topic.subject)
  step %Q{"I Have" tab should be highlighted}
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

Given /^I visit a topic page$/ do
  visit topic_path(@topic)
end


Given /^I visit my have topic$/ do
  visit have_path(@have_topic)
end

Then /^I should not see any topic recommendation$/ do
  page.should_not have_css("#topic-recommended")
  page.should_not have_css("#topic-not-recommended")
end

Then /^I should be able to recommend the topic$/ do
  page.find(".topic-recommend li a").click
  wait_for_ajax_call_to_finish
  page.should have_css("#topic-recommended")
  page.should_not have_css("#topic-not-recommended")
end

Then /^I should be able to not recommend the topic$/ do
  page.all(".topic-recommend li a").last.click
  wait_for_ajax_call_to_finish
  page.should_not have_css("#topic-recommended")
  page.should have_css("#topic-not-recommended")
end

Then /^I should be able to edit topic review to "(.*?)"$/ do |review|
  click_link "Update"
  fill_in("topic_body", with: review)
  click_button("Save")

  page.should have_content(review)
end

Then /^I should able to destroy the topic$/ do
  click_link "Remove"
  page.should have_content("The item has been removed")
end

Given /^I visit a have topic$/ do
  visit have_path(@have_topic)
  current_path.should == have_path(@have_topic)
end

Given /^I vote "(.*?)" from list view$/ do |vote|
  page.within("#topic-list-entry-#{@topic.id}") do
    links = page.all(".vote-icons a")
    vote == "Yes!" ? links.first.click : links.last.click
    wait_for_ajax_call_to_finish
  end

  page.should have_content(I18n.t("voting.success"))
end

def check_vote_status(topic, voted_yes)
  page.within("#topic-list-entry-#{topic.id} .vote-icons") do
    if voted_yes
      page.should have_css(".vote-yes.checked")
      page.should_not have_css(".vote-no.checked")
    else
      page.should_not have_css(".vote-yes.checked")
      page.should have_css(".vote-no.checked")
    end
  end
end

Given /^I should see my vote as "(.*?)" from list view$/ do |vote|
  check_vote_status(@topic, vote == "Yes!")
end


def recomend_topic_from_list_view(topic, recommend)
  page.within("#topic-list-entry-#{topic.id}") do
    links = page.all(".vote-icons a")
    recommend ? links.first.click : links.last.click
    wait_for_ajax_call_to_finish
  end

  page.should have_content(I18n.t("recommend.success"))
end

Given /^I recommend the topic from list view$/ do
  recomend_topic_from_list_view(@have_topic, true)
end

Then /^I dont recommend the topic from list view$/ do
  recomend_topic_from_list_view(@have_topic, false)
end

Then /^I should see my recommendation as "(.*?)" from list view$/ do |recommend|
  check_vote_status(@have_topic, recommend == "Yes!")
end


Given /^the user has another topic$/ do
  @mightbuy_topic = FactoryGirl.create(:topic, user: @user, subject: "MacBook")
end
