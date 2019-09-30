class AddActiveStatusToPassenger < ActiveRecord::Migration[5.2]
  def change
    add_column :passengers, :active_status, :integer, default: 0
  end
end
