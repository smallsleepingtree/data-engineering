require 'spec_helper'

describe User do
  describe 'validations' do
    it 'requires unique email address' do
      existing_user = FactoryGirl.create(:user)
      new_user = User.new
      new_user.email = existing_user.email
      new_user.should_not be_valid
      new_user.errors[:email].should_not be_empty
    end
  end
end
