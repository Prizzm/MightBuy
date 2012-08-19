require 'spec_helper'

describe "NewTopics" do
  it "logs in user" do
    user = Factory(:user)
    visit new_user_session_path
    fill_in "user_email", :with => user.email
    fill_in "user_password", :with => "asdfasdf"
    click_button "Login!"
    click_link "Add"
    
    fill_in "topic[subject]", :with => "Test Item"
    fill_in "topic[url]", :with => "http://test.com/test_item"
    fill_in "topic[price]", :with => "15"
    click_button "Save!"
    current_path.should include("topic")
  end
end
