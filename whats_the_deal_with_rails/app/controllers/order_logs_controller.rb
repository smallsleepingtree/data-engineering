class OrderLogsController < ApplicationController
  def new
    @order_log = OrderLog.new
  end

  def create
    redirect_to :action => :new
  end
end
