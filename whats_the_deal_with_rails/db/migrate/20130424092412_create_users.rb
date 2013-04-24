class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, :null => false
      t.string :password_digest, :null => false
      t.boolean :authorized, :null => false, :default => false
      t.boolean :admin, :null => false, :default => false

      t.timestamps
    end

    add_index :users, :email, :unique => true
  end
end
