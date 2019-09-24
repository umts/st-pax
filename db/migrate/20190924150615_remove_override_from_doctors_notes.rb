class RemoveOverrideFromDoctorsNotes < ActiveRecord::Migration[5.2]
  def change
    remove_column :doctors_notes, :overridden_by_id, :integer
    remove_column :doctors_notes, :override_until, :date
    remove_column :doctors_notes, :override_expiration, :boolean
  end
end
