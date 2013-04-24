class OrderLogsController < ApplicationController
  def new
    @order_log = OrderLog.new
  end

  def create
    @order_log = OrderLog.new
    @order_log.source_data = params[:order_log][:source_data] if params[:order_log]
    @order_log.save!
    flash[:notice] = t('order_log.uploaded')
    redirect_to :action => :new
  rescue ActiveRecord::RecordInvalid => e
    render :new
  end
end
