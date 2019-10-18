class AddFieldsToDoctorsNote < ActiveRecord::Migration[5.2]
  def change
    add_column :doctors_notes, :doctors_address, :text
    add_column :doctors_notes, :doctors_phone, :text
    add_column :doctors_notes, :doctors_name, :string
  end
end
