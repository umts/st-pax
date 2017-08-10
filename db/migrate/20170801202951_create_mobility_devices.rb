class CreateMobilityDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :mobility_devices do |t|
      t.string :device
      t.boolean :lift_ramp

      t.timestamps
    end
  end
end
