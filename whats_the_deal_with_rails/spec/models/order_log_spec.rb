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
end
