class CreateVerifyingAgencies < ActiveRecord::Migration[5.2]
  def change
    create_table :verifying_agencies do |t|
      t.string :name
      t.boolean :needs_contact_info, default: false
    end
  end
end
