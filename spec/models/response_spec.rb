require 'spec_helper'

describe Response do
  describe "Creating Votes and Comments" do
    before (:each) do
      @bob   = FactoryGirl.create(:user, name: "Bob")
      @tyler = FactoryGirl.create(:user, name: "Tyler")
      @topic = FactoryGirl.create(:topic, user: @bob)

      @yes   = @topic.responses.create!(user: @tyler, body: "yes",   recommend_type: "recommend")
      @no    = @topic.responses.create!(user: @tyler, body: "no",    recommend_type: "not_recommended")
      @maybe = @topic.responses.create!(user: @tyler, body: "maybe", recommend_type: "undecided")
      @why_no = Response.create(topic: @topic, user: @tyler, reply: @no, body: "why is it no!?")

      @yes.update_attributes(created_at: 6.hours.ago, updated_at: 16.hours.ago)
      @no.update_attributes(created_at: 5.hours.ago, updated_at: 15.hours.ago)
      @maybe.update_attributes(created_at: 4.hours.ago, updated_at: 14.hours.ago)
      @why_no.update_attributes(created_at: 2.hours.ago, updated_at: 12.hours.ago)
    end

    it "should create a vote for yes properly" do
      vote = @yes.create_vote!
      vote.topic.should == @topic
      vote.user.should  == @tyler
      vote.buyit?.should be_true
      vote.created_at.should == @yes.created_at
      vote.updated_at.should == @yes.updated_at

      Vote.count.should == 1
    end

    it "should create a vote for no properly" do
      vote = @no.create_vote!
      vote.buyit?.should be_false
    end

    it "should create a vote for maybe properly" do
      vote = @maybe.create_vote!
      vote.buyit?.should be_false
    end

    it "should create comment properly" do
      comment = @yes.create_nested_comments!
      comment.topic.should == @topic
      comment.user.should  == @tyler
      comment.parent.should be_nil
      comment.description.should == @yes.body
      comment.created_at.should == @yes.created_at
      comment.updated_at.should == @yes.updated_at

      Comment.count.should == 1
    end

    it "should create nested comments properly" do
      no_comment     = @no.create_nested_comments!
      why_no_comment = (Comment.all - [no_comment]).first

      Comment.all.length.should == 2
      why_no_comment.parent.should == no_comment
      why_no_comment.description.should == @why_no.body
    end

    it "should have interface to create all votes" do
      votes = Response.create_votes!
      votes.count.should == 2
      votes.map(&:buyit).should =~ [true, false]
    end

    it "should have interface to create all comments" do
      top_comments = Response.create_comments!
      top_comments.count.should == 3
      Comment.count.should == 4
      top_comments.map(&:description).should =~ [@yes, @no, @maybe].map(&:body)
    end
  end
end
