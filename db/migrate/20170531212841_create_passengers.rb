class CreatePassengers < ActiveRecord::Migration[5.1]
  def change
    create_table :passengers do |t|
      t.string :name
      t.string :email
      t.string :address
      t.string :phone
      t.boolean :wheelchair
      t.boolean :active
      t.boolean :permanent

      t.timestamps
    end
  end
end
