class CreateVerificationSources < ActiveRecord::Migration[5.2]
  def change
    create_table :verification_sources do |t|
      t.string :name
      t.boolean :needs_contact_info, default: false
    end
  end
end
