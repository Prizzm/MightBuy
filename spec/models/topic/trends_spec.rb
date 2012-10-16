require "spec_helper"

describe "Topic trends" do
  describe "topics with most comments" do
    before do
      @topics = create_topic_with_comments
    end

    it "should return topic with most comments" do
      topics = Topic.with_most_comments
      topics.first.should == @topics[1]
      topics[1].should == @topics[0]
      topics[2].should == @topics[2]
    end
  end

  describe "trending topics" do
    before do
      @topics = []
      @product1 = FactoryGirl.create(:product, url: "google.com")
      # 0,1
      2.times { @topics << FactoryGirl.create(:topic, url: "google.com") }

      @product2 = FactoryGirl.create(:product, url: "amazon.com")
      # 2
      @topics << FactoryGirl.create(:topic, url: "amazon.com")

      @product3 = FactoryGirl.create(:product, url: "apple.com")
      # 3,4,5,6
      4.times { @topics << FactoryGirl.create(:topic, url: "apple.com") }

      # 7,8,9
      @topics += create_topic_with_comments

      # 10
      @topics << FactoryGirl.create(:topic, url: "google.com")
      5.times { FactoryGirl.create(:comment, topic: @topics[10]) }
    end

    it "should return trending topics" do
      topics = Topic.trending_topics()

      topics[0].url.should match(/apple.com/)
    end
  end


end
