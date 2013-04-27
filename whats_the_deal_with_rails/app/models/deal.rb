class Deal < ActiveRecord::Base
  include MoneyColumn::StoresMoney
  stores_money :price, :cents_attribute => "price_cents"

  belongs_to :merchant

  validates :description, :presence => true
  validates :price, :presence => true
  validates :merchant, :presence => true
  validates_associated :merchant

  delegate :name, :address, :to => :merchant, :prefix => true

  def self.from_log_entry(entry)
    item_price = entry['item price'].to_money.cents
    merchant = Merchant.from_log_entry(entry)
    deal = where({
      :merchant_id => merchant,
      :description => entry['item description'],
      :price_cents => item_price
    }).first_or_initialize
    deal.merchant ||= merchant
    deal
  end
end
