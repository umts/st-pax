class AddSubscribedToSmsToPassengers < ActiveRecord::Migration[5.2]
   def up
    add_column :passengers, :subscribed_to_sms, :boolean, default: false
    add_column :passengers, :carrier_id, :int
  end

  def down
    remove_column :passengers, :subscribed_to_sms
    remove_column :passengers, :carrier_id
  end
end
