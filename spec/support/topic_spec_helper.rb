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
  def create_topic_with_comments
    topics = []
    topics << FactoryGirl.create(:topic, url: "reddit.com")
    2.times { FactoryGirl.create(:comment, topic: topics[0] )}

    topics << FactoryGirl.create(:topic, url: "gnu.org")
    3.times { FactoryGirl.create(:comment, topic: topics[1] )}

    topics << FactoryGirl.create(:topic, url: "redhat.com")
    FactoryGirl.create(:comment, topic: topics[2])
    topics
  end
end
