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
  page.find(".topic-title a").click
  @browse_topic_title = page.find(".topic-subject").text()
end

Then /^I should be able to add the topic to might buy list$/ do
  page.find(".dropdown-menu a", :text => "I might buy").click
  page.should have_content("Item copied to your list")
  step %Q{"I might buy" tab should be highlighted}
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
