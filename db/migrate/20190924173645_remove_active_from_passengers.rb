class RemoveActiveFromPassengers < ActiveRecord::Migration[5.2]
  def change
    remove_column :passengers, :active, :integer
  end
end
