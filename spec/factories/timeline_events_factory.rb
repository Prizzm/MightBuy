FactoryGirl.define do
  factory :timeline_event do
    actor  { FactoryGirl.create(:user) }

    factory :timeline_event_for_vote do
      subject  { FactoryGirl.create(:vote) }
      secondary_subject  { subject.topic }
    end
  end
end
