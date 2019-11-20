class RenameDoctorsNoteToEligibilityVerification < ActiveRecord::Migration[5.2]
  def change
    rename_table :doctors_notes, :eligibility_verifications
  end
end
