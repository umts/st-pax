class AddMissingAttributesToPassengers < ActiveRecord::Migration[5.1]
  def change
    add_column :passengers, :spire, :string
    add_column :passengers, :status, :string
    add_column :passengers, :registered_by, :integer
    add_column :passengers, :registered_with_disability_services, :boolean
    add_column :passengers, :has_brochure, :boolean
  end
end
