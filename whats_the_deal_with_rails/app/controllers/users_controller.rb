class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.save!
    flash[:notice] = t('user.created')
    session[:user_id] = @user.id
    redirect_to limbo_url
  rescue ActiveRecord::RecordInvalid => e
    render :new
  end
end
