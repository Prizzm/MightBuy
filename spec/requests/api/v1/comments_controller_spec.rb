require 'spec_helper'

describe "Comments API" do
  describe "Returning comments for topic" do
    before do
      @user = FactoryGirl.create(:user)
      @topic = FactoryGirl.create(:topic, user: @user)
      @comment = FactoryGirl.create(:comment, user: @user, topic: @topic)
    end

    it "Should return all comments for topic by id" do
      @user.ensure_authentication_token!
      token = @user.authentication_token
      get "/api/v1/comments?auth_token=#{token}&topic_id=#{@topic.id}"
      response.should be_success
      json_response = JSON.parse(response.body)
      json_response.should_not be_empty
    end
    it "Should return all comments for topic by shortcode" do
      @user.ensure_authentication_token!
      token = @user.authentication_token
      get "/api/v1/comments?auth_token=#{token}&topic_shortcode=#{@topic.shortcode}"
      response.should be_success
      json_response = JSON.parse(response.body)
      json_response.should_not be_empty
    end
    it "Should return error because neither id nor shortcode were specified" do
      @user.ensure_authentication_token!
      token = @user.authentication_token
      get "/api/v1/comments?auth_token=#{token}"
      response.code.should eq("500")
      response.body.should == '{"error":{"description":"No Topic Specified"}}'
    end
  end
end
