class AddSpireUniqueIndices < ActiveRecord::Migration[6.1]
  def change
    add_index :passengers, :spire
    add_index :users, :spire, unique: true
  end
end
