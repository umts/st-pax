class AddAccessIdToMobilityDevice < ActiveRecord::Migration[5.1]
  def change
    add_column :mobility_devices, :access_id, :integer
  end
end
