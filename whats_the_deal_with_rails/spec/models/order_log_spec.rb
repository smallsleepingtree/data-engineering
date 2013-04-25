require 'spec_helper'

describe OrderLog do
  describe 'validation' do
    it 'fails if source_data is nil' do
      subject.should_not be_valid
      subject.errors[:source_data].should_not be_empty
    end

    it 'fails if source_data is blank' do
      subject.source_data = ''
      subject.should_not be_valid
      subject.errors[:source_data].should_not be_empty
    end

    it 'fails if source_data is not tab-delimited' do
      subject.source_data = 'Oh no I forgot to pay my tab'
      subject.should_not be_valid
      subject.errors[:source_data].should_not be_empty
    end

    it 'succeeds if source_data is tab-delimited' do
      subject.source_data = "I could live\ton tabs\talone"
      subject.valid?
      subject.errors[:source_data].should be_empty
    end
  end

  describe '#source_data=' do
    it 'populates source_data from given IO stream' do
      path = path_to_fixture('order_logs/valid.tab')
      subject.source_data = File.new(path)
      subject.source_data.should == File.read(path)
    end

    it 'populates source_data from given string' do
      string = "I don't respond well to reading; I am not a book, you nerd"
      subject.source_data = string
      subject.source_data.should == string
    end
  end

  describe '#gross_revenue' do
    it 'returns 0 if no orders' do
      subject.gross_revenue.should be_zero
    end

    it 'returns calculated gross revenue if orders' do
      subject.source_data = File.new(path_to_fixture('order_logs/valid.tab'))
      subject.create_orders!
      subject.gross_revenue.should == 95.0
    end

    it 'returns cached value if requested' do
      subject.gross_revenue_cents = 2100
      subject.gross_revenue(:cached => true).should == 21.00
    end

    it 'calculates anyway if no cached value exists' do
      subject.source_data = File.new(path_to_fixture('order_logs/valid.tab'))
      subject.create_orders!
      subject.gross_revenue(:cached => true).should == 95.0
    end
  end

  describe '#after_create' do
    it 'creates orders' do
      subject.source_data = "Drink a slab\tof diet tab"
      subject.should_receive(:create_orders!)
      subject.save!
      subject.should_receive(:create_orders!).never
      subject.save!
    end
  end

  describe '#order_lines_from_source_data' do
    it 'returns array containing a hash for each order line' do
      subject.source_data = File.new(path_to_fixture('order_logs/valid.tab'))
      subject.order_lines_from_source_data.should == [
        {"purchaser name" => "Snake Plissken", "item description" => "$10 off $20 of food", "item price" => "10.0", "purchase count" => "2", "merchant address" => "987 Fake St", "merchant name" => "Bob's Pizza"},
        {"purchaser name" => "Amy Pond", "item description" => "$30 of awesome for $10", "item price" => "10.0", "purchase count" => "5", "merchant address" => "456 Unreal Rd", "merchant name" => "Tom's Awesome Shop"},
        {"purchaser name" => "Marty McFly", "item description" => "$20 Sneakers for $5", "item price" => "5.0", "purchase count" => "1", "merchant address" => "123 Fake St", "merchant name" => "Sneaker Store Emporium"},
        {"purchaser name" => "Snake Plissken", "item description" => "$20 Sneakers for $5", "item price" => "5.0", "purchase count" => "4", "merchant address" => "123 Fake St", "merchant name" => "Sneaker Store Emporium"}
      ]
    end
  end

  describe '#create_orders!' do
    it 'creates orders for each order line' do
      subject.source_data = File.new(path_to_fixture('order_logs/valid.tab'))
      subject.create_orders!
      subject.orders.count.should == 4
      subject.orders.map(&:deal_description).should =~ [
        "$10 off $20 of food", "$30 of awesome for $10", "$20 Sneakers for $5", "$20 Sneakers for $5"
      ]
    end

    it 'leaves well enough alone if orders already exist' do
      subject.source_data = "valid\tbut harmless"
      order = FactoryGirl.create(:order, :order_log => subject)
      subject.orders(true).should == [order]
      subject.source_data = File.new(path_to_fixture('order_logs/valid.tab'))
      subject.create_orders!
      subject.orders.should == [order]
    end

    it 'refreshes order list if force option sent' do
      subject.source_data = "valid\tbut harmless"
      order = FactoryGirl.create(:order, :order_log => subject)
      subject.orders(true).should == [order]
      subject.source_data = File.new(path_to_fixture('order_logs/valid.tab'))
      subject.create_orders!(:force => true)
      subject.orders.count.should == 4
    end
  end

  describe '#uploader_email' do
    it 'delegates to uploader' do
      ol = FactoryGirl.create(:order_log)
      ol.uploader = FactoryGirl.create(:user, :email => 'testme@example.com')
      ol.uploader_email.should == 'testme@example.com'
    end

    it 'returns nil if no uploader' do
      ol = FactoryGirl.create(:order_log)
      ol.uploader_email.should be_nil
    end
  end
end
