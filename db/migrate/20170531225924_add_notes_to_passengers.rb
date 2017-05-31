class AddNotesToPassengers < ActiveRecord::Migration[5.1]
  def change
    add_column :passengers, :note, :text
  end
end
