require 'spec_helper'

describe Deal do
  describe '#merchant attributes' do
    it 'delegates to merchant' do
      merchant = FactoryGirl.create(:merchant)
      deal = FactoryGirl.create(:deal, :merchant => merchant)
      deal.merchant_name.should == merchant.name
      deal.merchant_address.should == merchant.address
    end
  end

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

    it 'creates a deal from an entry in the order log' do
      deal = Deal.from_log_entry(log_entry)
      deal.description.should == '$10 off $20 of food'
      deal.price.should == '10.0'
      deal.merchant_address.should == '987 Fake St'
      deal.merchant_name.should == "Bob's Pizza"
      deal.should_not be_persisted
    end

    it 'returns existing deal looked up by entry' do
      existing_merchant = FactoryGirl.create(:merchant, :name => "Bob's Pizza", :address => "987 Fake St")
      existing_deal = FactoryGirl.create(:deal, :description => '$10 off $20 of food', :price => '10', :merchant => existing_merchant)
      deal = Deal.from_log_entry(log_entry)
      deal.should == existing_deal
    end
  end
end
