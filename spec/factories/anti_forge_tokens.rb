# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :anti_forge_token do
    value "MyString"
    date_created "2012-08-18"
    active ""
  end
end
