require 'spec_helper'

describe Customer do
  describe '.from_log_entry' do
    let(:log_entry) {
      {
        "purchaser name" => "Snake Plissken",
        "item description" => "$10 off $20 of food",
        "item price" => "10.0",
        "purchase count" => "2",
        "merchant address" => "987 Fake St",
        "merchant name" => "Bob's Pizza"
      }
    }

    it 'creates a customer from an entry in the order log' do
      customer = Customer.from_log_entry(log_entry)
      customer.name.should == 'Snake Plissken'
      customer.should_not be_persisted
    end

    it 'returns existing customer looked up by entry' do
      existing_customer = FactoryGirl.create(:customer, :name => 'Snake Plissken')
      customer = Customer.from_log_entry(log_entry)
      customer.should == existing_customer
    end
  end
end
