require 'spec_helper'

describe "Comments for api" do
  describe "Returning topic comments" do
    before do
      @user = FactoryGirl.create(:user)
      @topic = FactoryGirl.create(:topic, user: @user)
      @comment = FactoryGirl.create(:comment, user: @user, topic: @topic)
    end

    it "should return topic comments" do
      @user.ensure_authentication_token!
      token = @user.authentication_token
      get "/api/v1/comments?auth_token=#{token}&topic_id=#{@topic.id}"
      response.should be_success
      json_response = JSON.parse(response.body)
      json_response.should_not be_empty
    end
  end
end
