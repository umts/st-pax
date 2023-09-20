class AddUidAndNetIdToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :uid, :string
    add_column :users, :net_id, :string

    add_index :users, :uid
    add_index :users, :net_id
  end
end
