require 'spec_helper'

feature 'user administration' do
  let(:admin) { FactoryGirl.create(:admin_user) }

  scenario 'approving user created through form' do
    visit new_user_url
    fill_in :user_email, :with => 'fake@email.com'
    fill_in :user_password, :with => 'password'
    fill_in :user_password_confirmation, :with => 'password'
    click_button 'register-button'
    sign_out

    sign_in :as => admin
    visit users_url
    click_link I18n.t('user.administration.authorize')
    page.should have_content(I18n.t('user.authorized'))
    user = User.where(:email => 'fake@email.com').first
    user.should be_authorized
  end
end