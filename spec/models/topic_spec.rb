require 'spec_helper'

describe Topic do
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:status) }
  it { should ensure_inclusion_of(:status).in_array(["imightbuy", "ihave"]) }

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
      topic = Topic.build_from_form_data(@topic_data, current_user,"hello")
      topic.should_not be_nil
      topic.save.should be_true
    end

    it "shoudlc create topic with tags" do
      topic = Topic.build_from_form_data(@topic_data.update('tags' => ["emacs","vim"]),current_user, 'hello')

      topic.should_not be_nil
      topic.save.should be_true
      topic.tags.should_not be_empty
      topic.tags.map(&:name).should == ["emacs","vim"]
    end

    it "should not create new tags for existing ones" do
      tag = FactoryGirl.create(:tag, name: "emacs")
      topic_details_with_tags = @topic_data.update('tags' => ['emacs','vim'])
      Tag.count.should == 1

      topic = Topic.build_from_form_data(topic_details_with_tags,current_user,'hello')

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

  describe "Interface" do
    it "should return short url properly" do
      topic = FactoryGirl.build(:topic, url: "http://helloworld.com")
      topic.short_url.should_not be_empty
      topic.short_url.should == topic.url + "..."
    end

    it "should truncate url to first 40 characters" do
      long_url = "http://" + "wiki"*10 + "remainder.com"
      topic = FactoryGirl.build(:topic, url: long_url)
      topic.short_url.size.should == 43
      topic.short_url.should_not match(/remainder/)
    end

    it "should return empty string if url is not present" do
      topic = FactoryGirl.build(:topic, url: nil)
      topic.short_url.should_not be_nil
      topic.short_url.should be_empty
    end
  end

  describe "copying topics to my own list" do
    before {
      @topic = FactoryGirl.create(:topic, user: current_user)
      @tag = FactoryGirl.create(:tag)
      @topic.tags << @tag
    }

    it "should let me copy the topic" do
      another_user = FactoryGirl.create(:user)
      new_topic = @topic.copy(another_user)
      t = new_topic.save
      t.should be_true
      new_topic.subject.should == @topic.subject
      new_topic.user.should == another_user
      new_topic.tags.should include(@tag)
    end
  end

  describe "State Transitions" do
    before (:each) do
      @topic = FactoryGirl.create(:topic)
    end

    it "should be in i mightbuy state by default" do
      @topic.imightbuy?.should be_true
    end

    it "should transition to i have when bought" do
      @topic.bought!.should be_true
      @topic.ihave?.should be_true
    end
  end
end
