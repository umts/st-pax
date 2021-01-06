class CreateCarriers < ActiveRecord::Migration[5.2]
  def up
    create_table :carriers do |t|
      t.string :name
      t.string :gateway_address
    end
  end

  def down
    drop_table :carriers
  end
end
