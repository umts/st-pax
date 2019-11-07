class AddVerificationSourceIdToVerifications < ActiveRecord::Migration[5.2]
  def change
    add_column :verifications, :verification_source_id, :integer
  end
end
