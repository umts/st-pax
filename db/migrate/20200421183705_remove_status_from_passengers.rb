class RemoveStatusFromPassengers < ActiveRecord::Migration[5.2]
  def change
    remove_column :passengers, :status, :string
  end
end
