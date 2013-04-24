class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :create]
  before_filter :require_admin!, :only => [:index, :reject, :authorize]

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

  def index
    @pending_users = User.pending
  end

  def authorize
    @user = User.find_by_id!(params[:id])
    @user.authorize!
    flash[:notice] = t('user.authorized')
    redirect_to :action => :index
  end

  def reject
    @user = User.find_by_id!(params[:id])
    @user.reject!
    flash[:notice] = t('user.rejected')
    redirect_to :action => :index
  end
end
