class AddMobilityDeviceIdToPassengers < ActiveRecord::Migration[5.1]
  def change
    add_column :passengers, :mobility_device_id, :integer
  end
end
