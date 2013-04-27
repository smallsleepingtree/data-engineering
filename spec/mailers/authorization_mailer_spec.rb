require "spec_helper"

describe AuthorizationMailer do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin_user) }

  describe '#pending_authorization' do
    let(:mail) { AuthorizationMailer.pending_authorization(user, admin) }

    it 'has the correct subject' do
      mail.subject.should == I18n.t('mail.authorization.pending.subject')
    end

    it 'is sent to the admin' do
      mail.to.should include(admin.email)
    end

    it "includes the user's email address" do
      mail.body.should match(user.email)
    end
  end

  describe '#authorize_notification' do
    let(:mail) { AuthorizationMailer.authorize_notification(user) }

    it 'has the correct subject' do
      mail.subject.should == I18n.t('mail.authorization.authorize.subject')
    end

    it 'is sent to the user' do
      mail.to.should include(user.email)
    end
  end

  describe '#reject_notification' do
    let(:mail) { AuthorizationMailer.reject_notification(user) }

    it 'has the correct subject' do
      mail.subject.should == I18n.t('mail.authorization.reject.subject')
    end

    it 'is sent to the user' do
      mail.to.should include(user.email)
    end
  end
end
