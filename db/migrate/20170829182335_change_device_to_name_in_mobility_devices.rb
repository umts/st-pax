class ChangeDeviceToNameInMobilityDevices < ActiveRecord::Migration[5.1]
  def change
    rename_column :mobility_devices, :device, :name
  end
end
