require "spec_helper"

describe CommentsMailer do
  describe ".email_topic_owner" do
    context "when a comment is supplied to formulate an email" do
      let(:comment) { FactoryGirl.create(:comment) }
      let(:topic)   { comment.topic }
      let(:mail)    { CommentsMailer.email_topic_participant(topic.user, comment) }

      it "has commenter's name in from" do
        from_field = mail[:from].to_s
        from_field.should match(/#{comment.user.name.downcase}/i)
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

      it "has comment in the body" do
        mail.body.should match(comment.description)
      end
    end
  end
end
