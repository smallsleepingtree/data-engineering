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
end
