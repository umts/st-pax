class AddUniqeIndices < ActiveRecord::Migration[6.1]
  def change
    add_index :eligibility_verifications, :passenger_id, unique: true
    add_index :mobility_devices, :name, unique: true
    add_index :verifying_agencies, :name, unique: true
  end
end
