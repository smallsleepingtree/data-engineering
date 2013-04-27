FactoryGirl.define do
  factory :merchant do
    sequence(:name) { |n| "Customer #{n}" }
    address { "100#{name} Merchant Street" }
  end
end