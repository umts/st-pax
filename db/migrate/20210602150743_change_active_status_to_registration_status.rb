class ChangeActiveStatusToRegistrationStatus < ActiveRecord::Migration[6.1]
  def up
    rename_column :passengers, :active_status, :registration_status
  end
  def down
    rename_column :passengers, :registration_status, :active_status
  end
end
