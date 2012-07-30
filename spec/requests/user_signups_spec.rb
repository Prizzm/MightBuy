require 'spec_helper'

describe "UserSignups" do
  it "Signs up user" do
    visit new_user_registration_path
    fill_in "user[name]", :with => "Joe Doe"
    fill_in "user[email]", :with => "joe@doe.com"
    fill_in "user[password]", :with => "abcdefg"
    click_button "Join!"
    current_path.should eq("/me")
  end
end
