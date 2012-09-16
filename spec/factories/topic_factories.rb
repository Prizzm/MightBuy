# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:shortcode) {|count| "hell#{count}" }

  factory :topic do
    subject "Jeans"
    access "private"
    form   "recommendation"
    shortcode  { FactoryGirl.generate(:shortcode) }
    after_build {|topic|
      topic.user ||= FactoryGirl.create(:user)
    }
  end
end
