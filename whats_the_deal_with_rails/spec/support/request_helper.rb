def sign_in(options = {})
  options[:as] ||= user
  options[:password] ||= 'password'

  visit new_session_url
  fill_in :session_email, :with => options[:as].email
  fill_in :session_password, :with => options[:password]
  click_button 'signin-button'
end

def stub_openid_agent(options = {})
  response = double('response',
    :status => options[:status] || :success,
    :identity_url => options[:identity_url],
    :message => options[:message]
  )
  openid_agent = OpenidAgent.new({})
  openid_agent.should_receive(:complete)
  openid_agent.stub!(:response).and_return(response)
  OpenidAgent.stub!(:new).and_return(openid_agent)
end
