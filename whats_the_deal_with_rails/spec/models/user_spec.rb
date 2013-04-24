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

  describe '.pending' do
    it 'includes all users who are not authorized but also not rejected' do
      User.pending.to_sql.should ==
        User.where(:authorized => false, :rejected_at => nil).to_sql
    end
  end

  describe '#authorize!' do
    let(:user) { FactoryGirl.create(:user) }

    it 'sets authorized to true' do
      user.should_not be_authorized
      user.authorize!
      user.should be_authorized
    end

    it 'clears rejected_at if set' do
      user.rejected_at = Time.now
      user.save!
      user.authorize!
      user.rejected_at.should be_nil
    end

    it 'sends an email to the user' do
      mailer = double('mailer')
      mailer.should_receive(:deliver)
      AuthorizationMailer.stub!(:authorize_notification).and_return(mailer)
      user.authorize!
    end
  end

  describe '#reject!' do
    let(:user) { FactoryGirl.create(:authorized_user) }

    it 'sets authorized to false' do
      user.should be_authorized
      user.reject!
      user.should_not be_authorized
    end

    it 'sets rejected_at' do
      user.rejected_at.should be_nil
      user.reject!
      user.rejected_at.should_not be_nil
    end

    it 'sends an email to the user' do
      mailer = double('mailer')
      mailer.should_receive(:deliver)
      AuthorizationMailer.stub!(:reject_notification).and_return(mailer)
      user.reject!
    end
  end
end
