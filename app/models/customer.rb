class Customer < ActiveRecord::Base
  def self.from_log_entry(entry)
    where(:name => entry['purchaser name']).first_or_initialize
  end
end
