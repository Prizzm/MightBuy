require 'spec_helper'

describe Vote do
  it { should validate_presence_of(:topic) }
  let(:current_user) { FactoryGirl.create(:user) }

  describe "capture timeline event on vote" do
    it "should capture timeline events when someone votes" do
      topic = FactoryGirl.create(:topic)
      vote = FactoryGirl.create(:vote, user: current_user, topic: topic)
      current_user.timeline_events.should_not be_empty
      subjects = current_user.timeline_events.map(&:subject)
      subjects.should include(vote)

      vote_event = current_user.timeline_events.detect { |e| e.subject == vote }
      vote_event.activity_line.should =~ /Joe doe liked/i
    end

    it "deleting topic should remove the event" do
      topic = FactoryGirl.create(:topic)
      vote = FactoryGirl.create(:vote, user: current_user, topic: topic)
      subjects = current_user.timeline_events.map(&:subject)
      subjects.should include(vote)
      topic.destroy
      current_user.reload

      current_user.timeline_events.should be_empty
    end
  end

  describe "#activity_line" do
    let(:event)  { FactoryGirl.create(:timeline_event_for_vote) }
    let(:vote)   { event.subject }

    context "when timeline event has valid topic owner" do
      it "returns valid topic owner link and name" do
        vote.activity_line(event).should_not match(/anonymous/i)
      end
    end

    context "when timeline event has invalid topic owner" do
      let(:topic)    { event.secondary_subject }
      before(:each)  { topic.user.delete; topic.reload }

      it "returns anonymous as topic owner name" do
        vote.activity_line(event).should match(/anonymous/i)
      end
    end
  end
end
