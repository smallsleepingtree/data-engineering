class CreateOrderLogs < ActiveRecord::Migration
  def change
    create_table :order_logs do |t|
      t.integer :gross_revenue_cents
      t.text :source_data

      t.timestamps
    end
  end
end
