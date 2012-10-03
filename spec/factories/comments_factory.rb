FactoryGirl.define do
  factory :comment do
    description "Hello world"
    after_build do |c|
      c.user ||=  FactoryGirl.create(:user)
      c.topic ||= FactoryGirl.create(:topic)
    end
  end
end
