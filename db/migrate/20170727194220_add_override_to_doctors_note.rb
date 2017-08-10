class AddOverrideToDoctorsNote < ActiveRecord::Migration[5.1]
  def change
    add_column :doctors_notes, :override_expiration, :boolean
  end
end
