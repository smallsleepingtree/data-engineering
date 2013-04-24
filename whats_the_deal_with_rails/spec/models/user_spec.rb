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

  describe 'after_create' do
    it 'sends an email to the admin if user is unauthorized' do
      admin = FactoryGirl.create(:admin_user)
      mailer = double('mailer')
      mailer.should_receive(:deliver)
      AuthorizationMailer.stub!(:pending_authorization).and_return(mailer)
      user = FactoryGirl.create(:user)
    end

    it 'does not send an email to the admin if user is authorized' do
      admin = FactoryGirl.create(:admin_user)
      AuthorizationMailer.should_receive(:pending_authorization).never
      user = FactoryGirl.create(:authorized_user)
    end

    it 'does not send an email to the admin if new user is also admin' do
      admin = FactoryGirl.create(:admin_user)
      AuthorizationMailer.should_receive(:pending_authorization).never
      user = FactoryGirl.create(:admin_user, :email => 'admin2@example.com')
    end

    it 'does not send an email if no admin exists' do
      AuthorizationMailer.should_receive(:pending_authorization).never
      user = FactoryGirl.create(:user)
    end
  end
end
