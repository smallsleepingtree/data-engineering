class SessionsController < ApplicationController
  before_filter :require_anonymity!, :only => [:new, :create]

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to root_url, :notice => t('session.created')
    else
      flash.now[:alert] = t('session.failed_authentication')
      render :new
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

  def require_anonymity!
    if user_signed_in?
      redirect_to root_url, :notice => t('session.redundant')
    end
  end
end
