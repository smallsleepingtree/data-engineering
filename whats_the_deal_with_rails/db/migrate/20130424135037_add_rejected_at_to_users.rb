class AddRejectedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rejected_at, :datetime
  end
end
