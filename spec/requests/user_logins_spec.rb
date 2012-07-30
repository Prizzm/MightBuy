require 'spec_helper'

describe "UserLogins" do
  it "logs in user" do
    user = Factory(:user)
    visit new_user_session_path
    fill_in "user_email", :with => user.email
    fill_in "user_password", :with => "asdfasdf"
    click_button "Login!"
    current_path.should eq("/me")
  end
end