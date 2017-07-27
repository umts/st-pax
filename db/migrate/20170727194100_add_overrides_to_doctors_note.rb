class AddOverridesToDoctorsNote < ActiveRecord::Migration[5.1]
  def change
    add_column :doctors_notes, :override_until, :date
  end
end
