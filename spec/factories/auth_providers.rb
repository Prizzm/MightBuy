# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :auth_provider do
    provider "MyString"
    uid "MyString"
  end
end
