require "spec_helper"

describe "Topics for api" do
  describe "returning trending topics" do
    before do
      @user = FactoryGirl.create(:user)
      @topics = create_topic_with_comments
    end

    it "should return trending topics" do
      @user.ensure_authentication_token!
      token = @user.authentication_token
      get "/api/v1/topics/trending?auth_token=#{token}"
      response.should be_success

      json_response = JSON.parse(response.body)
      json_response.should_not be_empty
    end
  end
end
