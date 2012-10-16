<<<<<<< HEAD
require 'spec_helper'

describe "User API" do
  describe "Returning user info" do
    before do
      @user = FactoryGirl.create(:user)
      @topic = FactoryGirl.create(:topic, user: @user)
      @topic = FactoryGirl.create(:topic, user: @user)
      @topic = FactoryGirl.create(:topic, user: @user)
    end

    it "Should return user's topics" do
      @user.ensure_authentication_token!
      token = @user.authentication_token
      get "/api/v1/topics.json?auth_token=#{token}"
      response.should be_success
      json_response = JSON.parse(response.body)
      json_response.count.should == 3
      json_response.should_not be_empty
    end
    
    it "Should return third topic" do
      @user.ensure_authentication_token!
      token = @user.authentication_token
      get "/api/v1/search.json?auth_token=#{token}&q=#{@topic.subject}"
      response.should be_success
      puts response.body
=======
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

>>>>>>> master
      json_response = JSON.parse(response.body)
      json_response.should_not be_empty
    end
  end
end
