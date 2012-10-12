require 'spec_helper'

describe "User API" do
  describe "Returning user info" do
    before do
      @user = FactoryGirl.create(:user)
      @topic = FactoryGirl.create(:topic, user: @user)
      @comment = FactoryGirl.create(:comment, user: @user, topic: @topic)
    end

    it "Should return user info" do
      @user.ensure_authentication_token!
      token = @user.authentication_token
      get "/api/v1/user/info.json?auth_token=#{token}"
      response.should be_success
      json_response = JSON.parse(response.body)
      json_response.should_not be_empty
    end
  end
end
