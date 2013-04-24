Given /^(I am|there is) an administrator$/ do |who_is|
  @mental_admin_user = {
    :email => 'admin@example.com',
    :password => 'password'
  }
  user = FactoryGirl.create(:admin_user, {
    :email => @mental_admin_user[:email],
    :password => @mental_admin_user[:password]
  })
  if who_is == 'I am'
    @current_user = user
    @mental_user = @mental_admin_user
  end
end

When /^I choose to (authorize|reject) the user's request$/ do |decision|
  click_link "#{decision}_user_#{@pending_user.id}_authorization"
end

Then /^I (don't )?see the user in the authorization pending list$/ do |do_not|
  visit users_url
  email = @mental_pending_user[:email]
  within('#pending-authorizations') do
    if do_not
      page.should_not have_content(email)
    else
      page.should have_content(email)
    end
  end
end

Then /^the user is (not )?authorized to upload files$/ do |is_not|
  @pending_user.reload
  if is_not
    @pending_user.should_not be_authorized
  else
    @pending_user.should be_authorized
  end
end

Then /^the user receives an email about their (approved|rejected) authorization$/ do |decision|
  email = ActionMailer::Base.deliveries.last
  email.to.should include(@pending_user.email)
  email.body.should include(decision)
end