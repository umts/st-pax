class CreateDoctorsNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :doctors_notes do |t|
      t.integer :passenger_id
      t.date :expiration_date
      t.integer :overriden_by

      t.timestamps
    end
  end
end
