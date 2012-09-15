require 'spec_helper'

describe Topic do
  it {
    should validate_presence_of(:subject)
  }
  let(:current_user) { FactoryGirl.create(:user) }

  describe "returning topic image thumbnail" do
    it "should return image of appropriate thumbnail" do
      topic = FactoryGirl.create(:topic)
      topic.thumbnail_image.should == "/assets/no_image.png"
    end
  end

  describe "creating new topis" do
    before do
      @topic_data = {
        "subject"=>"htc one x", "url"=>"http://www.htc.com/www/smartphones/", 
        "image_url"=>"http://www.htc.com/managed-assets/www/smartphones/htc-one-x/explorer/htc-one-x.png",
        "price"=>"9", "body"=>"asdsa"
      }
    end
    it "should create new topics from forms without image" do
      topic = Topic.create_from_from_data(@topic_data, current_user,"hello")
      topic.should_not be_nil
      topic.save.should be_true
    end

    it "shoudlc create topic with tags" do
      topic = Topic.create_from_from_data(@topic_data.update('tags' => ["emacs","vim"]),current_user, 'hello')

      topic.should_not be_nil
      topic.save.should be_true
      topic.tags.should_not be_empty
      topic.tags.map(&:name).should == ["emacs","vim"]
    end
  end
end
