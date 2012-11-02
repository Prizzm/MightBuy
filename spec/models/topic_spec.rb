require 'spec_helper'

describe Topic do
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:recommendation) }
  it { should ensure_inclusion_of(:status).in_array(["imightbuy", "ihave"]) }
  it { should ensure_inclusion_of(:recommendation).
    in_array(["undecided", "recommended", "not-recommended"]) }

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
      topic.timeline_events.should_not be_empty
      current_user.timeline_events.should_not be_empty
    end

    it "should create topic with partially invalid image URLs" do
      partially_invalid_urls = [
        "http://www.motorola.com/staticfiles/Consumers/Products/Mobile%20Phones/DROID-RAZR-by-Motorola/_Promotions/_Images/_Staticfiles/feature_brick_availability_A.png",
        "http://s7d4.scene7.com/is/image/roomandboard/?src=ir{roomandboardrender/sanna_chr_20?obj=main&sharp=1&src=rpt_cambridgegrey&illum=0&obj=material&src=drape_material_cc}&$truvu0$&wid=307",
        "http://rubyliving.com/catalog/images/products/marison-diningtable[1].jpg"
      ]

      partially_invalid_urls.each do |image_url|
        topic = Topic.build_from_form_data(@topic_data.update('image_url' => image_url), current_user,"hello")
        topic.should_not be_nil
        topic.save.should be_true
      end
    end

    it "should create topic with tags" do
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

    it "should replace tags when updating" do
      @topic.tags.should include(@tag)
      @topic.update_tags(["emacs"])
      @topic.reload
      @topic.tags.should_not include(@tag)
      @topic.tags.map(&:name).should include("emacs")
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

    it "should copy have topic to mightbuy list" do
      topic = FactoryGirl.create(:topic, status: "ihave")
      new_topic = topic.copy(current_user)
      new_topic.save.should be_true
      new_topic.ihave?.should be_false
    end
  end

  describe "fetching public topics" do
    before do
      @topic = FactoryGirl.create(:topic, user: current_user)
      @another_topic = FactoryGirl.create(:topic)
    end

    it "given a user it should fetch all topics not belonging to him" do
      topics = Topic.except_user_topics(1,current_user)
      topics.should_not include(@topic)
      topics.should include(@another_topic)
    end

    it "should return all topics if not given a user" do
      topics = Topic.except_user_topics(1)
      topics.should include(@topic)
      topics.should include(@another_topic)
    end
  end

  describe "recommendation states on topics" do
    before (:each) do
      @topic = FactoryGirl.create(:topic)
    end

    it "should have undecided as default state" do
      @topic.recommendation.should == "undecided"
      @topic.recommended?.should be_false
      @topic.not_recommended?.should be_false
    end

    it "should be able to recommend the topic" do
      @topic.update_attributes(recommendation: "recommended").should be_true

      @topic.recommended?.should be_true
      @topic.not_recommended?.should be_false
    end

    it "should be able to not recommend the topic" do
      @topic.update_attributes(recommendation: "not-recommended").should be_true

      @topic.recommended?.should be_false
      @topic.not_recommended?.should be_true
    end
  end

  describe "#commenters" do
    let(:tyler)  { FactoryGirl.create(:user, name: "Tyler") }
    let(:marla)  { FactoryGirl.create(:user, name: "Marla") }
    let(:watch)  { FactoryGirl.create(:topic, subject: "Rolex", user: tyler) }

    context "when there are no comments" do
      it "returns no commenters" do
        watch.commenters.should be_empty
      end

      it "returns no commenters excluding requested commenter" do
        watch.commenters.exclude(tyler).should be_empty
      end
    end

    context "when there are comments by others" do
      # make sure that we have 3 comments here to validate uniqueness ...
      let(:buyit)    { FactoryGirl.create(:comment, topic: watch, user: marla) }
      let(:yousure)  { FactoryGirl.create(:comment, topic: watch, user: tyler) }
      let(:ofcourse) { FactoryGirl.create(:comment, topic: watch, user: marla) }
      before(:each)  { [buyit, yousure, ofcourse] }

      it "returns all unique commenters" do
        watch.commenters =~ [tyler, marla]
      end

      it "returns commenters excluding requested commenter" do
        watch.commenters.exclude(tyler) =~ [marla]
      end
    end
  end

  describe "#ordered_comments" do
    let(:topic)  { FactoryGirl.create(:topic) }
    let(:buyit)  { FactoryGirl.create(:comment, topic: topic) }
    let(:nonono) { FactoryGirl.create(:comment, topic: topic) }
    let(:comments) { [buyit, nonono] }
    before(:each)  { comments; buyit.update_attributes(created_at: 2.hours.ago) }

    it "returns all the comments" do
      topic.ordered_comments =~ comments
    end

    it "returns buyit as first comment" do
      topic.ordered_comments[0].should == buyit
    end
  end
end
