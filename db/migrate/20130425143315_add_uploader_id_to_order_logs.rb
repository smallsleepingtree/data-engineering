class AddUploaderIdToOrderLogs < ActiveRecord::Migration
  def change
    add_column :order_logs, :uploader_id, :integer
  end
end
