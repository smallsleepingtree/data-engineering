require 'spec_helper'

describe Order do
  describe '#total' do
    it 'returns the price * quantity for the order' do
      deal = FactoryGirl.create(:deal, :price => '18.50')
      subject.deal = deal
      subject.quantity = 3
      subject.total.should == 55.50
    end
  end

  describe '.from_log_entry' do
    it 'creates an order from an entry in the order log' do
      log_entry = {
        "purchaser name" => "Snake Plissken",
        "item description" => "$10 off $20 of food",
        "item price" => "10.0",
        "purchase count" => "2",
        "merchant address" => "987 Fake St",
        "merchant name" => "Bob's Pizza"
      }
      order = Order.from_log_entry(log_entry)
      order.customer_name.should == 'Snake Plissken'
      order.deal_description.should == '$10 off $20 of food'
      order.deal_price.should == 10.0
      order.merchant_name.should == "Bob's Pizza"
      order.merchant_address.should == '987 Fake St'
      order.quantity.should == 2
      order.total.should == 20.0
    end

    it 'associates with existing entities if matched' do
      customer = FactoryGirl.create(:customer, :name => 'Boodlebox Moontuck')
      merchant = FactoryGirl.create(:merchant, :name => 'Benny the Crumpkin Baker', :address => 'Farm')
      deal = FactoryGirl.create(:deal, :description => 'Cheap Fancies', :price => 8.50, :merchant => merchant)

      log_entry = {
        "purchaser name" => "Boodlebox Moontuck",
        "item description" => "Cheap Fancies",
        "item price" => "8.50",
        "purchase count" => "3",
        "merchant address" => "Farm",
        "merchant name" => "Benny the Crumpkin Baker"
      }
      order = Order.from_log_entry(log_entry)
      order.customer.should == customer
      order.deal.should == deal
      order.merchant.should == merchant
      order.quantity.should == 3
      order.total.should == 25.5
    end
  end

  describe 'delegation' do
    let(:merchant) { FactoryGirl.create(:merchant) }
    let(:deal) { FactoryGirl.create(:deal, :merchant => merchant) }
    let(:customer) { FactoryGirl.create(:customer) }
    let(:order) { FactoryGirl.create(:order, :deal => deal, :customer => customer) }

    describe '#merchant' do
      it 'delegates to deal' do
        order.merchant.should == merchant
      end
    end

    describe '#merchant attributes' do
      it 'delegate to merchant through deal' do
        order.merchant_name.should == merchant.name
        order.merchant_address.should == merchant.address
      end
    end

    describe '#customer_name' do
      it 'delegates to customer' do
        order.customer_name.should == customer.name
      end
    end

    describe '#deal attributes' do
      it 'delegate to deal' do
        order.deal_description.should == deal.description
        order.deal_price.should == deal.price
      end
    end
  end
end
