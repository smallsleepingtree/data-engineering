require 'spec_helper'

feature 'Limbo' do
  let(:unauthorized_user) { FactoryGirl.create(:user) }
  let(:authorized_user) { FactoryGirl.create(:user, :authorized => true) }

  scenario 'is for authenticated but unauthorized users' do
    sign_in :as => unauthorized_user
    page.should have_content I18n.t('titles.limbo')
  end

  scenario 'is inaccessible to authorized users' do
    sign_in :as => authorized_user
    visit limbo_url
    page.should_not have_content I18n.t('titles.limbo')
  end

  scenario 'is inaccessible to unauthenticated users' do
    visit limbo_url
    page.should_not have_content I18n.t('titles.limbo')
  end
end