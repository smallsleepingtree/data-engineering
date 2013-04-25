class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.string :description, :null => false
      t.integer :price_cents, :null => false
      t.references :merchant, :null => false

      t.timestamps
    end

    add_index :deals, [:merchant_id, :description, :price_cents], :unique => true,
      :name => 'index_deals_on_merchant_description_price'
  end
end
