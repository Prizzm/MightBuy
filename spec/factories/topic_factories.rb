# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:shortcode) {|count| "hell#{count}" }

  factory :topic do
    subject "Jeans"
    access "private"
    shortcode  { FactoryGirl.generate(:shortcode) }
  end
end