class RemoveCarrier < ActiveRecord::Migration[6.1]
  def change
    drop_table :carriers
  end
end
