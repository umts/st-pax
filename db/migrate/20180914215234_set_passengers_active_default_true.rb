class SetPassengersActiveDefaultTrue < ActiveRecord::Migration[5.1]
  def change
    change_column :passengers, :active, :boolean, default: true
  end
end
