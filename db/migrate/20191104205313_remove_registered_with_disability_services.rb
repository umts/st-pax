class RemoveRegisteredWithDisabilityServices < ActiveRecord::Migration[5.2]
  def change
    remove_column :passengers, :registered_with_disability_services, :boolean
  end
end
