class RenameDoctorsNoteToVerification < ActiveRecord::Migration[5.2]
  def change
    rename_table :doctors_notes, :verifications
  end
end
