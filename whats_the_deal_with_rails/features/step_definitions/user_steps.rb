Given /^I am an (un)?authorized user$/ do |unauthorized|
  @mental_user = {
    :email => 'user@example.com',
    :password => 'password'
  }
  @current_user = FactoryGirl.create(:user, {
    :email => @mental_user[:email],
    :password => @mental_user[:password],
    :authorized => !unauthorized
  })
end

Given /^I do not have a user account$/ do
  # no-op step, only for specification clarity
end

When /^I sign in$/ do
  visit new_session_url
  fill_in :session_email, :with => @mental_user[:email]
  fill_in :session_password, :with => @mental_user[:password]
  click_button 'commit-button'
end

Then /^I am informed that I am unauthorized$/ do
  page.should have_content(I18n.t('unauthorized'))
end

Then /^I am asked to sign in$/ do
  page.should have_content(I18n.t('session.needed'))
end
