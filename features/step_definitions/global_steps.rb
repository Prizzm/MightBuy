Then /^I should see "(.*?)"$/ do |content|
  page.should have_content(content)
end

Then /^I should not see "(.*?)"$/ do |content|
  page.should_not have_content(content)
end

And /^I should see :"([^\"]*)"$/ do |key|
  string = I18n.t(key)
  step %Q{I should see "#{string}"}
end

When /^I visit the home page$/ do
  visit('/')
end

When /^I visit the manage voucher page$/ do
  visit('/seller/vouchers')
end

When /^I click "(.*?)"$/ do |link_text|
	click_link(link_text)
end

When /^save and open page$/ do
  save_and_open_page
end

When /^show me the page$/ do
  save_and_open_page
end

def wait_for_ajax_call_to_finish
  keep_looping = true
  while keep_looping do
    # TODO: Test this. It might be more efficient by sleeping for < 1 second.
    sleep 1
    begin
      count = page.evaluate_script('window.running_ajax_calls').to_i
      keep_looping = false if count == 0
    rescue => e
      if e.message.include? 'HTMLunitCorejsJavascript::Undefined'
        raise "For 'I wait for the AJAX call to finish' to work, please include culerity.js after including jQuery."
      else
        raise e
      end
    end
  end
end

# wait for AJAX call stuff.
When /^I wait for the AJAX call to finish$/ do
  wait_for_ajax_call_to_finish
end
