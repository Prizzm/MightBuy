require 'spec_helper'

describe VotesMailerJob do
  describe "#perform" do
    before(:each)  { VotesMailer.deliveries.clear }
    let(:topic)  { FactoryGirl.create(:topic) }
    let(:job)    { VotesMailerJob.new(vote.id) }
    let(:mail)   { VotesMailer.deliveries.first }

    context "when a user votes" do
      let(:vote)  { FactoryGirl.create(:vote, topic: topic) }
      before(:each)  { job.perform }

      it "sends an email" do
        mail.should_not be_nil
      end
    end

    context "when topic owner votes" do
      let(:vote)  { FactoryGirl.create(:vote, topic: topic, user: topic.user) }
      before(:each)  { job.perform }

      it "doesnot sends any email" do
        mail.should be_nil
      end
    end
  end
end
