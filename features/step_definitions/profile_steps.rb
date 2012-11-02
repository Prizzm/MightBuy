When /^I visit profile page of "(.*?)"$/ do |name|
  user = User.find_by_name(name)
  visit user_path(user)
end

Then /^I should see mightbuy items of "(.*?)"$/ do |name|
  user = User.find_by_name(name)

  page.should have_content("#{user.name.capitalize}'s Might Buy")
  page.within("#user-mightbuy-topics") do
    page.should have_css("#topic-#{@mightbuy_topic.id}-img")
  end
end

Then /^I should see have items of "(.*?)"$/ do |name|
  user = User.find_by_name(name)

  page.should have_content("#{user.name.capitalize} Has")
  page.within("#user-have-topics") do
    page.should have_css("#topic-#{@have_topic.id}-img")
  end
end

When /^I visit my profile page$/ do
  visit user_path(@user)
end

Then /^I should my mightbuy items$/ do
  page.should have_content("I Might Buy")
  page.within("#user-mightbuy-topics") do
    page.should have_css("#topic-#{@mightbuy_topic.id}-img")
  end
end

Then /^I should my have items$/ do
  page.should have_content("I Have")
  page.within("#user-have-topics") do
    page.should have_css("#topic-#{@have_topic.id}-img")
  end
end
