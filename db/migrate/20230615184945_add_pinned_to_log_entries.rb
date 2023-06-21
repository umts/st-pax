class AddPinnedToLogEntries < ActiveRecord::Migration[6.1]
  def change
    add_column :log_entries, :pinned, :boolean, default: false, null: false
  end
end
