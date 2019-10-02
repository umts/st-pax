class AddActiveStatusDataToPassengers < ActiveRecord::Migration[5.2]
  def up
    Passenger.all.each do |passenger|
      if passenger.read_attribute(:active) == true
        passenger.active_status = 'active'
      else
        passenger.active_status = 'archived'
      end
      # there are invalid (no email) passengers in the database.
      passenger.save(validate: false)
    end
  end

  def down
    Passenger.all.each do |passenger|
      passenger.active = passenger.active?
      passenger.save(validate: false)
    end
  end
end
