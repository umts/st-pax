class RemoveBadColumnsFromPassenger < ActiveRecord::Migration[5.1]
  def change
    remove_column :passengers, :note_expiration
    remove_column :passengers, :expdate
  end
end
