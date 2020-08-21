class RemoveHasBrochureFromPassengers < ActiveRecord::Migration[5.2]
  def change
    remove_column :passengers, :has_brochure, :boolean
  end
end
