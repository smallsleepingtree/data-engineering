Given /^there is an administrator$/ do
  @mental_admin_user = {
    :email => 'admin@example.com',
    :password => 'password'
  }
  FactoryGirl.create(:admin_user, {
    :email => @mental_admin_user[:email],
    :password => @mental_admin_user[:password]
  })
end