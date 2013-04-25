class SessionsController < ApplicationController
  before_filter :require_anonymity!, :only => [:new, :create]

  def new
  end

  def create
    p = params[:session]
    if p[:openid_url].present?
      create_using_openid_url(p[:openid_url])
    else
      create_using_email_and_password(p[:email], p[:password])
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

  def create_using_email_and_password(email, password)
    user = User.find_by_email(email)
    if user && user.authenticate(password)
      session[:user_id] = user.id
      redirect_to root_url, :notice => t('session.created')
    else
      flash.now[:alert] = t('session.failed_authentication')
      render :new
    end
  end

  def create_using_openid_url(openid_url)
    if url = openid_redirect_url(openid_url)
      redirect_to url
    else
      flash.now[:alert] = t('session.failed_openid_authentication')
      render :new
    end
  end

  def require_anonymity!
    if user_signed_in?
      redirect_to root_url, :notice => t('session.redundant')
    end
  end
end
