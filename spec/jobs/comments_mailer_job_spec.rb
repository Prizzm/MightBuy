require 'spec_helper'

describe CommentsMailerJob do
  describe "#mailable_topic_participants" do
    let(:owner)  { FactoryGirl.create(:user, name: "Tyler") }
    let(:user)   { FactoryGirl.create(:user, name: "Marla") }
    let(:watch)  { FactoryGirl.create(:topic, subject: "Rolex", user: owner) }

    context "when topic owner comments" do
      let(:canibuy)  { FactoryGirl.create(:comment, topic: watch, user: owner) }
      let(:job)      { CommentsMailerJob.new(canibuy.id) }

      it "returns empty participants" do
        job.mailable_topic_participants.should be_empty
      end

      context "when topic owner comments again" do
        before(:each) { [canibuy] }
        let(:anyone)  { FactoryGirl.create(:comment, topic: watch, user: owner) }
        let(:job)     { CommentsMailerJob.new(anyone.id) }

        it "returns empty participants" do
          job.mailable_topic_participants.should be_empty
        end
      end

      context "when another user comments" do
        before(:each) { [canibuy] }
        let(:buyit)   { FactoryGirl.create(:comment, topic: watch, user: user) }
        let(:job)     { CommentsMailerJob.new(buyit.id) }

        it "returns topic owner" do
          job.mailable_topic_participants =~ [owner]
        end
      end
    end

    context "when another user comments" do
      let(:welll)  { FactoryGirl.create(:comment, topic: watch, user: user) }
      let(:job)    { CommentsMailerJob.new(welll.id) }

      it "returns topic owner" do
        job.mailable_topic_participants =~ [owner]
      end

      context "when owner comments" do
        before(:each) { [welll] }
        let(:anyone)  { FactoryGirl.create(:comment, topic: watch, user: owner) }
        let(:job)     { CommentsMailerJob.new(anyone.id) }

        it "returns another user" do
          job.mailable_topic_participants =~ [user]
        end
      end

      context "when another user comments again" do
        before(:each) { [welll] }
        let(:buyit)   { FactoryGirl.create(:comment, topic: watch, user: user) }
        let(:job)     { CommentsMailerJob.new(buyit.id) }

        it "returns topic owner" do
          job.mailable_topic_participants =~ [owner]
        end
      end

      context "when a new user comments" do
        before(:each)   { [welll] }
        let(:new_user)  { FactoryGirl.create(:user) }
        let(:cantsay)   { FactoryGirl.create(:comment, topic: watch, user: new_user) }
        let(:job)       { CommentsMailerJob.new(cantsay.id) }

        it "returns topic owner and old user" do
          job.mailable_topic_participants =~ [owner, user]
        end
      end
    end
  end
end
