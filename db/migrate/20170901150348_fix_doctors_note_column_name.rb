class FixDoctorsNoteColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :doctors_notes, :overriden_by, :overridden_by
  end
end
