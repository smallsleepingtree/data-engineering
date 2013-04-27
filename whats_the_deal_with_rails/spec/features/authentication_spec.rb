require 'spec_helper'
require 'openid'

feature 'authentication' do
  let(:user) { FactoryGirl.create(:authorized_user) }

  scenario 'signing out' do
    sign_in
    click_link I18n.t('session.sign_out')
    page.should have_content(I18n.t('session.destroyed'))
    page.should_not have_content(user.email)
    page.should have_content(I18n.t('session.form.legend'))
  end

  scenario 'trying to sign in when already authenticated' do
    sign_in
    visit new_session_url
    page.should have_content(I18n.t('session.redundant'))
    page.should_not have_content(I18n.t('session.form.legend'))
  end
end