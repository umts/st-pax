class AddOverrideToPassenger < ActiveRecord::Migration[5.1]
  def change
    add_column :passengers, :override, :boolean
  end
end
