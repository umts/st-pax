class AddCarrierIdToPassengers < ActiveRecord::Migration[5.2]
  def change
    add_column :passengers, :carrier_id, :integer
  end
end
