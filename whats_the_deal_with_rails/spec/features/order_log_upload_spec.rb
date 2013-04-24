require 'spec_helper'

feature 'OrderLog upload' do
  let(:user) { FactoryGirl.create(:authorized_user) }

  scenario 'complains when no file is uploaded' do
    sign_in
    visit new_order_log_url
    click_button 'commit-button'
    page.should have_content I18n.t('errors.messages.blank')
  end

  scenario 'complains when non-tab-delimited file is uploaded' do
    sign_in
    visit new_order_log_url
    attach_file(:order_log_source_data, path_to_fixture('order_logs/invalid.txt'))
    click_button 'commit-button'
    page.should have_content I18n.t('errors.messages.not_tab_separated')
  end
end