class AddUidAndNetIdToPassenger < ActiveRecord::Migration[6.1]
  def change
    add_column :passengers, :uid, :string
    add_column :passengers, :net_id, :string

    add_index :passengers, :uid
    add_index :passengers, :net_id
  end
end
