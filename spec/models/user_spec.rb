require "spec_helper"

describe User, "authenticating using facebook" do
  it "should create user with email given correct response" do
    user = User.from_omniauth(auth_hash)
    user.should_not be_nil
    user.email.should == "hemant@example.com"
    user.image.should_not be_nil
  end

  it "should create slug for URL" do
    user = User.create(:email => "test@example.com", :name => "Fname Lname")
    user.should_not be_nil
    user.slug.should_not be_nil
  end
end
