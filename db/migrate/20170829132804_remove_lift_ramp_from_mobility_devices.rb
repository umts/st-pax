class RemoveLiftRampFromMobilityDevices < ActiveRecord::Migration[5.1]
  def change
    remove_column :mobility_devices, :lift_ramp, :boolean
  end
end
