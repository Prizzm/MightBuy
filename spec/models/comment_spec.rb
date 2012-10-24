require 'spec_helper'

describe Comment do
  it { should validate_presence_of(:topic) }
  it { should validate_presence_of(:description) }
  let(:current_user) { FactoryGirl.create(:user) }

  describe "capture timeline event for comment" do
    it "should capture timeline event if someone comments" do
      topic = FactoryGirl.create(:topic)
      comment = FactoryGirl.create(:comment, topic: topic, user: current_user)

      current_user.timeline_events.should_not be_empty

      comment_event = current_user.timeline_events.detect { |e| e.subject == comment}
      comment_event.activity_line.should =~ /#{current_user.name}/i
    end
  end

  describe "#send_notifications" do
    context "when invoked" do
      before(:each) { CommentsMailer.deliveries.clear }
      let(:comment) { FactoryGirl.create(:comment) }
      let(:mail)    { CommentsMailer.deliveries.first }

      it "sends an email to topic owner" do
        comment.send_notifications
        mail.should_not be_nil
      end
    end
  end
end
