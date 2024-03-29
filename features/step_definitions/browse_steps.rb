Then /^I should see my empty feed$/ do
  page.should have_content("My Activity feed")
  page.should have_content("I Might Buy")
end

Then /^I should see "(.*?)" feeds$/ do |name|
  page.should have_content("#{name}'s Activity feed")
  page.should have_content("#{name}'s Might Buy")
end


Then /^I browse for a topic$/ do
  click_link "Browse"

  topic = Topic.except_user_topics(1, @user).first
  topic.should_not be_nil
  page.find("#topic-browse-entry-#{topic.id} .topic-title a").click
  @browse_topic_title = page.find(".topic-subject").text()
end

Then /^I should be able to add the topic to might buy list$/ do
  page.find(".dropdown-menu a", :text => "I might buy").click
  page.should have_content("Item copied to your list")
  step %Q{"I MightBuy" tab should be highlighted}
  page.should have_content(@browse_topic_title)
end

Then /^I should be able to add the topic to have list$/ do
  page.find(".dropdown-menu a", :text => "I have").click

  review = "This is cool stuff!!"
  page.within(".edit_topic") do
    fill_in("topic_body", with: review)
    page.find("input[type='submit']").click
  end

  step %Q{"I Have" tab should be highlighted}
  page.should_not have_content("Unable to add to list")
  page.should have_content(review)
end

Given /^I vote "(.*?)" from browse view$/ do |vote|
  page.within("#topic-browse-entry-#{@topic.id}") do
    links = page.all(".vote-icons a")
    vote == "Yes!" ? links.first.click : links.last.click
    wait_for_ajax_call_to_finish
  end

  page.should have_content(I18n.t("voting.success"))
end

Then /^I should see my vote as "(.*?)" from browse view$/ do |vote|
  page.within("#topic-browse-entry-#{@topic.id} .vote-icons") do
    if vote == "Yes!"
      page.should have_css(".vote-yes.checked")
      page.should_not have_css(".vote-no.checked")
    else
      page.should_not have_css(".vote-yes.checked")
      page.should have_css(".vote-no.checked")
    end
  end
end

Then /^I should be able to add the topic from browse view$/ do
  page.within("#topic-browse-entry-#{@topic.id}") do
    click_link "Add_icon"
  end

  page.within(".modal.fade.in") do
    click_link("Add to 'I mightbuy' list")
  end

  page.should have_content("Item copied to your list")
end
