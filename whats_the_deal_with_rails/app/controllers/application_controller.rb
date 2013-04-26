require 'openid_agent'

class ApplicationController < ActionController::Base
  protect_from_forgery

private

  def authenticate_user!
    unless user_signed_in?
      redirect_to new_session_url, :notice => t('session.needed')
    end
  end

  def require_authorization!
    unless current_user.authorized?
      redirect_to limbo_url, :notice => t('unauthorized')
    end
  end

  def require_admin!
    unless current_user.admin?
      redirect_to root_url, :notice => t('unauthorized')
    end
  end

  def current_user
    @current_user ||= User.find_by_id!(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound => e
    session[:user_id] = nil
  end
  helper_method :current_user

  def user_signed_in?
    !!current_user
  end
  helper_method :user_signed_in?

  def user_authorized?
    user_signed_in? && current_user.authorized?
  end
  helper_method :user_authorized?

  def user_admin?
    user_signed_in? && current_user.admin?
  end
  helper_method :user_admin?

  def openid_redirect_url(openid_url, options = {})
    openid_agent.redirect_url(openid_url,
      :realm => root_url,
      :return_to => complete_openid_consumer_url(options[:passthrough]),
      :entity => options[:entity]
    )
  end

  def openid_agent
    @openid_agent ||= OpenidAgent.new(session)
  end
end
