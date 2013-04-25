class OrdersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_authorization!

  def index
    @orders = OrderLog.find_by_id!(params[:order_log_id]).orders
  end
end