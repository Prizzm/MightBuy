module TopicSpecHelper
  def create_topic_with_tags
    @tags = [FactoryGirl.create(:tag),FactoryGirl.create(:tag)]
    topic1 = FactoryGirl.create(:topic)
    topic1.tags << @tags[1]

    topic2 = FactoryGirl.create(:topic)
    topic2.tags << @tags[0]

    topic3 = FactoryGirl.create(:topic)
    topic3.tags << @tags[0]

    topic4 = FactoryGirl.create(:topic)
    topic4.tags << @tags[0]
    @topics = [topic1,topic2,topic3,topic4]
  end
end
