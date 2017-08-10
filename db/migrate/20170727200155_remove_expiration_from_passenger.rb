class RemoveExpirationFromPassenger < ActiveRecord::Migration[5.1]
  def change
    remove_column :passengers, :expiration, :date
  end
end
