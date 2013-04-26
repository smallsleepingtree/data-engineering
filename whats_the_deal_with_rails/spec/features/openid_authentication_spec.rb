require 'spec_helper'
require 'openid'

feature 'OpenID authentication' do
  let(:user) { FactoryGirl.create(:authorized_user, :password => nil, :openid_url => 'flabooble') }

  scenario 'when bad URL is entered' do
    visit new_session_url
    fill_in :session_openid_url, :with => 'obviously bad url'
    click_button 'signin-button'
    page.should have_content(I18n.t('errors.messages.bad_openid_url'))
  end

  scenario 'successful login' do
    stub_openid_agent(:identity_url => user.openid_url)
    visit complete_openid_consumer_url(:email => user.email)
    page.should have_content(I18n.t('session.created'))
  end

  scenario 'successful account creation' do
    stub_openid_agent(:identity_url => 'fundingo')
    visit complete_openid_consumer_url(:email => 'fundingo@email.com')
    page.should have_content(I18n.t('user.created'))
    page.should have_content('fundingo@email.com')
  end

  scenario 'failed login' do
    stub_openid_agent(:status => :failure, :message => 'oops')
    visit complete_openid_consumer_url
    page.should have_content(I18n.t('openid.failure', :message => 'oops'))
  end

  scenario 'cancelled login' do
    stub_openid_agent(:status => :cancel, :message => 'oops')
    visit complete_openid_consumer_url
    page.should have_content(I18n.t('openid.cancelled', :message => 'oops'))
  end

  scenario 'failed account creation' do
    stub_openid_agent(:status => :failure, :message => 'oops')
    visit complete_openid_consumer_url(:email => 'fundingo@email.com')
    page.should have_content(I18n.t('openid.failure', :message => 'oops'))
  end
end