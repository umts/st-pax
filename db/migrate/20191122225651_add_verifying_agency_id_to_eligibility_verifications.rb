class AddVerifyingAgencyIdToEligibilityVerifications < ActiveRecord::Migration[5.2]
  def change
    add_column :eligibility_verifications, :verifying_agency_id, :integer
  end
end
