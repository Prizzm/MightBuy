Then /^I should see my empty feed$/ do
  page.should have_content("My Activity feed")
  page.should have_content("My wants")
end

Then /^I should see "(.*?)" feeds$/ do |name|
  page.should have_content("#{name}'s Activity feed")
  page.should have_content("#{name}'s wants")
end
