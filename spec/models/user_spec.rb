require "spec_helper"

describe User, "authenticating using facebook" do
  it "should create user with email given correct response" do
    user = User.from_omniauth(auth_hash)
    user.should_not be_nil
    user.email.should == "hemant@example.com"
    user.image.should_not be_nil
  end
end
