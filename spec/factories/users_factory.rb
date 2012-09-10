FactoryGirl.define do
  
  factory :user do
    sequence(:email) { |i| "user-#{i}@prizzm.com" }
    password "asdfasdf"
    password_confirmation "asdfasdf"
    name "Joe Doe"
  end
  
  factory :bank, :class => "Points::Bank" do
    bankable { |bank| Factory(:user) }
  end
  
  factory :allocation, :class => "Points::Allocation" do
    bank { Factory(:bank)  }
    allocatable { Factory(:product) }
    allocator :facebook_like
  end
  
  factory :deal, :class => "Deals::Deal" do
    association :for, :factory => :product
    sequence(:title) { |i| "Deal #{i}" }
    low_cost 100
    low_value 0.10
    value_type "percent"
  end
  
  factory :redemption, :class => "Deals::Redemption" do
    user
    deal
    cost 100
    value 0.10
  end

end
