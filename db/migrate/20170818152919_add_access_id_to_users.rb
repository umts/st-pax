class AddAccessIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :access_id, :integer
  end
end
