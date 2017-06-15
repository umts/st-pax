class AddExpirationDateToPassengers < ActiveRecord::Migration[5.1]
  def change
    add_column :passengers, :expiration, :date
  end
end
