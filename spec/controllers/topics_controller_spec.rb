require "spec_helper"

describe TopicsController do
  describe "protected actions should redirect user" do
    before do
      @topic = FactoryGirl.create(:topic)
    end

    it "should redirect user when trying to fetch new" do
      get :new
      response.should redirect_to("/users/login")
    end

    it "should redirect user when trying access copy" do
      get :copy, id: @topic.to_param
      response.should redirect_to("/users/login")
    end
  end
end
