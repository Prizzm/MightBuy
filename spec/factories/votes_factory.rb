FactoryGirl.define do
  factory :vote do
    buyit true
    after_build do |vote|
      vote.user ||= FactoryGirl.create(:user)
      vote.topic ||=  FactoryGirl.create(:topic)
    end
  end
end
