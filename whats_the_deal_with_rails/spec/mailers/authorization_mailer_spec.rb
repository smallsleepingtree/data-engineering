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
end
