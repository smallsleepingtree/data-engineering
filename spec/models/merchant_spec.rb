require 'spec_helper'

describe Merchant do
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

    it 'creates a merchant from an entry in the order log' do
      merchant = Merchant.from_log_entry(log_entry)
      merchant.name.should == "Bob's Pizza"
      merchant.address.should == "987 Fake St"
      merchant.should_not be_persisted
    end

    it 'returns existing merchant looked up by entry' do
      existing_merchant = FactoryGirl.create(:merchant, :name => "Bob's Pizza", :address => '987 Fake St')
      merchant = Merchant.from_log_entry(log_entry)
      merchant.should == existing_merchant
    end
  end
end
