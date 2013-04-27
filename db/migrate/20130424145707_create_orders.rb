class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :quantity, :null => false
      t.references :customer, :null => false
      t.references :deal, :null => false
      t.references :order_log, :null => false

      t.timestamps
    end

    add_index :orders, :order_log_id
  end
end
