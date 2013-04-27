class SessionsController < ApplicationController
  before_filter :require_anonymity!, :only => [:new, :create]

  def new
    @session = Session.new
  end

  def create
    p = params[:session]
    @session = Session.new(p)
    if p[:openid_url].present?
      create_using_openid_url(p[:openid_url])
    elsif p[:email].present?
      create_using_email_and_password(p[:email], p[:password])
    else
      retry_invalid_session
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_url, :notice => t('session.destroyed')
  end

  def limbo
    authenticate_user!
    redirect_to root_url if user_authorized?
  end

private

  def retry_invalid_session(alert = nil)
    flash.now[:alert] = t(alert) if alert
    @session.valid?
    render :new
  end

  def create_using_email_and_password(email, password)
    user = User.find_by_email(email)
    if user && user.authenticate(password)
      session[:user_id] = user.id
      redirect_to root_url, :notice => t('session.created')
    else
      retry_invalid_session('session.failed_authentication')
    end
  end

  def create_using_openid_url(openid_url)
    if url = openid_redirect_url(openid_url, :entity => @session)
      redirect_to url
    else
      retry_invalid_session('session.failed_openid_authentication')
    end
  end

  def require_anonymity!
    if user_signed_in?
      redirect_to root_url, :notice => t('session.redundant')
    end
  end
end
