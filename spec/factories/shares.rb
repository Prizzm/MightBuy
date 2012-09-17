# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :share, :class => Shares::Share do
    topic
    user

    factory :email_share, :class => Shares::Email do
      with  "hello@example.com"
    end
  end
end
