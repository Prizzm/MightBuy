require "spec_helper"

describe VotesMailer do
  describe ".email_topic_owner" do
    context "when a vote is supplied to formulate an email" do
      let(:vote)  { FactoryGirl.create(:vote) }
      let(:topic) { vote.topic }
      let(:mail)  { VotesMailer.email_topic_owner(vote) }

      it "has voter's name in from" do
        from_field = mail[:from].to_s
        from_field.should match(/#{vote.user.name.downcase}/i)
      end

      it "has receiver's email in to" do
        mail.to.should include(topic.user.email)
      end

      it "has subject according to topic" do
        mail.subject.should match(topic.subject.first(45))
      end

      it "has topic url in the body" do
        mail.body.should match(topic_url(topic))
      end

      it "has upvote information in the body" do
        mail.body.should match(/upvoted/)
      end

      context "when downvoted" do
        let(:vote)  { FactoryGirl.create(:vote, buyit: false) }

        it "has downvote information in the body" do
          mail.body.should match(/downvoted/)
        end
      end
    end
  end
end
