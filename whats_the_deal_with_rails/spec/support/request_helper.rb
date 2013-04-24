def sign_in(options = {})
  options[:as] ||= user
  options[:password] ||= 'password'

  visit new_session_url
  fill_in :session_email, :with => options[:as].email
  fill_in :session_password, :with => options[:password]
  click_button 'commit-button'
end