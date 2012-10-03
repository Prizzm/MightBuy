require "spec_helper"

describe Topic::SocialIntegration do
  describe "posting to twitter" do
    use_vcr_cassette "posting to twitter"
    it "should allow posting to twitter" do
      user = FactoryGirl.create(:user, email: "hemant@codemancers.com")
      topic = FactoryGirl.create(:topic, user: user)

      topic.post_to_twitter(user)
    end
  end
end
