class AddSubscribedToSmsToPassengers < ActiveRecord::Migration[5.2]
  def change
    add_column :passengers, :subscribed_to_sms, :boolean, default: false
  end
end
