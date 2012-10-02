require 'spec_helper'

describe Api::V1::CommentsController do
  describe "Returning topic comments" do
    before do
      @user = FactoryGirl.create(:user)
      @topic = FactoryGirl.create(:topic, user: @user)
      @comment = FactoryGirl.create(:comment, user: @user, topic: @topic)
    end

    it "should return topic comments" do
      @user.ensure_authentication_token!
      token = @user.authentication_token
      params = {topic_id: @topic.id }
      get :index, params
      response.should be_success
      puts JSON.parse(response.body)
    end
  end
end
