Then /^I should see my empty feed$/ do
  page.should have_content("My Activity feed")
  page.should have_content("I Might Buy")
end

Then /^I should see "(.*?)" feeds$/ do |name|
  page.should have_content("#{name}'s Activity feed")
  page.should have_content("#{name} Might Buy")
end
