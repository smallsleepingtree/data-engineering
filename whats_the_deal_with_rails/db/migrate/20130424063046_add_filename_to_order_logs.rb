class AddFilenameToOrderLogs < ActiveRecord::Migration
  def change
    add_column :order_logs, :filename, :string
  end
end
