class RemoveWheelchairAndMobilityDeviceFromPassengers < ActiveRecord::Migration[5.1]
  def change
    remove_column :passengers, :wheelchair, :boolean
    remove_column :passengers, :mobility_device, :string
  end
end
