When /^I choose to upload a new file$/ do
  visit new_order_log_url
end

When /^I upload a valid file$/ do
  attach_file(:order_log_source_data, path_to_fixture('order_logs/valid.tab'))
  click_button 'commit-button'
end

Then /^I see a confirmation message$/ do
  page.should have_content(I18n.translate('order_log.uploaded'))
end
