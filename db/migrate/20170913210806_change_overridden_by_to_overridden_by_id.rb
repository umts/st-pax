class ChangeOverriddenByToOverriddenById < ActiveRecord::Migration[5.1]
  def change
    rename_column :doctors_notes, :overridden_by, :overridden_by_id
  end
end
