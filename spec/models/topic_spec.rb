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

    it "should not create new tags for existing ones" do
      tag = FactoryGirl.create(:tag, name: "emacs")
      topic_details_with_tags = @topic_data.update('tags' => ['emacs','vim'])
      Tag.count.should == 1

      topic = Topic.create_from_from_data(topic_details_with_tags,current_user,'hello')

      topic.should_not be_nil
      topic.save.should be_true
      topic.tags.should have(2).tags
      Tag.count.should == 2
    end
  end

  describe "updating a topic" do
    before do
      @topic = FactoryGirl.create(:topic, user: current_user)
      @tag = FactoryGirl.create(:tag, name: 'dell')
      @topic.tags << @tag

      @new_topic_details = {
        "subject" => "ips monitor", "url" => "http://www.dell.com/content/topics/topic.aspx/global/products/monitors/includes/en/ultrasharpmonitor_ips?c=us&l=en&cs=04", "image_url" => "/media/BAhbBlsHOgZmSSI5MjAxMi8wOS8xNi8wOV81MF8xNl83MzdfbW9uaXRvcl91bHRyYXNoYXJwX2lwc180LmpwZwY6BkVU",
        "price" => "9.0", "body" => "IPS monitors", "tags" => ["dell", "apple", "ruby"]
      }
    end

    it "should update topic without tags" do
      return_value = @topic.update_from_form_data(@new_topic_details,'hello_world')
      return_value.should be_true
      @topic.should have(3).tags
      @topic.subject.should == "ips monitor"
    end
  end

  describe "computing votes" do
    before do
      @topic = FactoryGirl.create(:topic, user: current_user)
    end

    it "should return percentage votes" do
      another_user = FactoryGirl.create(:user)
      @topic.vote(another_user,true)
      @topic.percentage_votes.should_not be_empty
      @topic.percentage_votes[:yes].should == 100
      @topic.percentage_votes[:no].should == 0
    end
  end
end
