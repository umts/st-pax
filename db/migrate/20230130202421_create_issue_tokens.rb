class CreateIssueTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :issue_tokens do |t|
      t.string :token
      t.integer :singleton

      t.timestamps
    end
    add_index :issue_tokens, :singleton, unique: true
  end
end
