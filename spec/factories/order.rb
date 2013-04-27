FactoryGirl.define do
  factory :order do
    customer
    deal
    order_log
    sequence(:quantity) { |n| n + 1 }
  end
end