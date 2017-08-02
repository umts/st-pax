class AddMobilityDeviceToPassenger < ActiveRecord::Migration[5.1]
  def change
    add_column :passengers, :mobility_device, :string
  end
end
