FactoryGirl.define do
  factory :deal do
    sequence(:description) { |n| "Only $#{n * 2} for a $#{n}" }
    sequence(:price_cents) { |n| n * 100 }
    merchant
  end
end