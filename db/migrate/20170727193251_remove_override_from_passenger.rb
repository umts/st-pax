class RemoveOverrideFromPassenger < ActiveRecord::Migration[5.1]
  def change
    remove_column :passengers, :override, :boolean
  end
end
