FactoryGirl.define do
  sequence :tag_name do |count|
    "apple#{count}"
  end

  factory :tag do
    name { FactoryGirl.generate(:tag_name) }
  end
end
