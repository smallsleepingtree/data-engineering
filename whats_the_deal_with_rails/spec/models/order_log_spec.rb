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

  describe '#calculate_gross_revenue!' do
    it 'returns 0 if no source data' do
      subject.calculate_gross_revenue!.should be_zero
    end

    it 'returns calculated gross revenue if source_data' do
      subject.source_data = File.new(path_to_fixture('order_logs/valid.tab'))
      subject.calculate_gross_revenue!.should == 95.0
    end

    it 'returns 0 if source_data not well-formed' do
      subject.source_data = "I am\tfull of\ttabs\nBUT I HAVE NO DEPTH\nand am unloved"
      subject.calculate_gross_revenue!.should be_zero
    end
  end

  describe '#before_save' do
    it 'calculates gross revenue from source data' do
      subject.source_data = "Drink a slab\tof diet tab"
      subject.should_receive(:calculate_gross_revenue!)
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
end
