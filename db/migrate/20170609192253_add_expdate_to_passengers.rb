class AddExpdateToPassengers < ActiveRecord::Migration[5.1]
  def change
    add_column :passengers, :expdate, :string
  end
end
