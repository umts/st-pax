class RemoveAccessIdFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :access_id, :integer
  end
end
