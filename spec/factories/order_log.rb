require_relative '../support/fixture_support'

FactoryGirl.define do
  factory :order_log do
    source_data {
      File.new(path_to_fixture('order_logs/valid.tab'))
    }
  end
end