class Merchant < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true

  def self.from_log_entry(entry)
    where(:name => entry['merchant name'], :address => entry['merchant address']).first_or_initialize
  end
end
