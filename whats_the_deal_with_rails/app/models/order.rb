class Order < ActiveRecord::Base
  belongs_to :deal
  belongs_to :customer
  belongs_to :order_log

  delegate :merchant, :to => :deal
  delegate :description, :price, :to => :deal, :prefix => true
  delegate :name, :to => :customer, :prefix => true
  delegate :name, :address, :to => :merchant, :prefix => true

  def total
    deal_price * quantity
  end

  def self.from_log_entry(entry)
    entry.assert_valid_keys(
      'purchaser name',
      'item description',
      'item price',
      'purchase count',
      'merchant address',
      'merchant name'
    )
    order = new
    order.customer = Customer.from_log_entry(entry)
    order.deal = Deal.from_log_entry(entry)
    order.quantity = entry['purchase count'].to_i
    order
  end
end
