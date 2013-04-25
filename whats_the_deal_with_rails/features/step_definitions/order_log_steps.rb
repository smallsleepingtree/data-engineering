Given /^an order log has been uploaded$/ do
  @order_log = OrderLog.new
  @order_log.source_data = File.new(path_to_fixture('order_logs/valid.tab'))
  @order_log.save!
end

When /^I choose to view the order log details$/ do
  visit order_log_orders_url(@order_log)
end

When /^I choose to upload a new file$/ do
  visit new_order_log_url
end

When /^I upload an? (in)?valid file$/ do |invalid|
  @uploaded_file = invalid ? 'invalid.txt' : 'valid.tab'
  attach_file(:order_log_source_data, path_to_fixture("order_logs/#{@uploaded_file}"))
  click_button 'commit-button'
end

Then /^I see a confirmation message$/ do
  page.should have_content(I18n.translate('order_log.uploaded'))
end

Then /^I see an error message$/ do
  page.should have_content(I18n.t('errors.messages.not_tab_separated'))
end

Then /^I (don't )?see the file in the list of recent uploads$/ do |do_not|
  visit order_logs_url # in case we're not already viewing the list
  if do_not
    page.should_not have_content(@uploaded_file)
  else
    page.should have_content(@uploaded_file)
  end
end

Then /^I do not see the order log details$/ do
  page.should_not have_css('#orders')
end

Then /^I see the gross revenue from the uploaded file$/ do
  page.should have_content(Money.parse('95.0').to_s)
end

Then /^I am not able to upload a file$/ do
  page.should_not have_css('#order_log_source_data')
end