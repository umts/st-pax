class CreateCarriers < ActiveRecord::Migration[5.2]
  def change
    create_table :carriers do |t|
      t.string :name
      t.string :gateway_address
    end
  end
end
