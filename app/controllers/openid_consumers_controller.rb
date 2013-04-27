class OpenidConsumersController < ApplicationController
  def complete
    openid_params = params.reject { |k,v| [request.path_parameters.keys, 'action', 'controller'].flatten.include?(k) }
    openid_agent.user_attributes = { :email => params.delete(:email) }
    openid_agent.complete(openid_params, complete_openid_consumer_url)
    openid_response = openid_agent.response

    @user = openid_agent.user

    if openid_agent.status == :success
      if @user.persisted?
        flash[:notice] = t('session.created')
        next_url = root_url
      else
        begin
          @user.save!
          flash[:notice] = t('user.created')
          next_url = limbo_url
        rescue ActiveRecord::RecordInvalid => e
          render 'users/new' and return
        end
      end
      session[:user_id] = @user.id
      redirect_to next_url
    else
      flash[:error] = t("openid.#{openid_agent.status}", :message => openid_response.message)
      if @user.persisted?
        redirect_to new_session_url
      else
        redirect_to new_user_url
      end
    end
  end
end