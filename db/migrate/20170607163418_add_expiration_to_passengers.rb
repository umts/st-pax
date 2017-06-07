class AddExpirationToPassengers < ActiveRecord::Migration[5.1]
  def change
    add_column :passengers, :note_expiration, :time
  end
end
