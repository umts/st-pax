class AddNeedsLongerRidesToMobilityDevices < ActiveRecord::Migration[5.1]
  def change
    add_column :mobility_devices, :needs_longer_rides, :boolean,
               default: false, null: false
  end
end
