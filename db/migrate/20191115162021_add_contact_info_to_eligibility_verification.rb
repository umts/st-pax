class AddContactInfoToEligibilityVerification < ActiveRecord::Migration[5.2]
  def change
    add_column :eligibility_verifications, :name, :string
    add_column :eligibility_verifications, :address, :text
    add_column :eligibility_verifications, :phone, :string
  end
end
