class AddOpenidUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :openid_url, :string
  end
end
