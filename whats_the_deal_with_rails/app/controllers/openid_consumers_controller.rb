require 'openid'

class OpenidConsumersController < ApplicationController
  def complete
    openid_params = params.reject { |k,v| [request.path_parameters.keys, 'action', 'controller'].flatten.include?(k) }
    email = params.delete(:email)
    openid_response = openid_consumer.complete(openid_params, complete_openid_consumer_url)

    @user = User.find_by_openid_url(openid_response.identity_url)

    case openid_response.status
    when OpenID::Consumer::FAILURE
      flash[:error] = t('openid.failure', :message => openid_response.message)
      fail(@user)
    when OpenID::Consumer::SUCCESS
      if @user 
        flash[:success] = t('session.created')
        session[:user_id] = @user.id
        redirect_to root_url
      else
        begin
          @user = User.new(:email => email, :openid_url => openid_response.identity_url)
          @user.save!
          flash[:notice] = t('user.created')
          session[:user_id] = @user.id
          redirect_to limbo_url
        rescue ActiveRecord::RecordInvalid => e
          render 'users/new'
        end
      end
    when OpenID::Consumer::CANCEL
      flash[:alert] = t('openid.cancelled')
      fail(@user)
    else
    end
  end

private

  def fail(user)
    if user
      redirect_to new_session_url
    else
      redirect_to new_user_url
    end
  end
end