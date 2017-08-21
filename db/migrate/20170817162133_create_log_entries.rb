class CreateLogEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :log_entries do |t|
      t.integer :user_id
      t.text :text

      t.timestamps
    end
  end
end
