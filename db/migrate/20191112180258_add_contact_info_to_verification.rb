class AddContactInfoToVerification < ActiveRecord::Migration[5.2]
  def change
    add_column :verifications, :name, :string
    add_column :verifications, :address, :text
    add_column :verifications, :phone, :string
  end
end
