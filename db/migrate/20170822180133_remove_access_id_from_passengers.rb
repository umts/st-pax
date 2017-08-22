class RemoveAccessIdFromPassengers < ActiveRecord::Migration[5.1]
  def change
    remove_column :passengers, :access_id, :integer
  end
end
