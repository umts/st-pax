class AddPreferredNameToPassengers < ActiveRecord::Migration[5.2]
  def change
    add_column :passengers, :preferred_name, :string
  end
end
