class RemoveCarrierIdFromPassengers < ActiveRecord::Migration[6.1]
  def change
    remove_column :passengers, :carrier_id, :integer
  end
end
