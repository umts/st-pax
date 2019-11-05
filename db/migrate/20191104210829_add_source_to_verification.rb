class AddSourceToVerification < ActiveRecord::Migration[5.2]
  def change
    add_column :verifications, :source, :integer
  end
end
