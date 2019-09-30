class AddActiveStatusDataToPassengers < ActiveRecord::Migration[5.2]
  def up
    Passenger.all.each do |passenger|
      if passenger.read_attribute(:active) == true
        passenger.active!
      else
        passenger.archived!
      end
    end
  end

  def down
    Passenger.all.each do |passenger|
      passenger.active = true
      passenger.save
    end
  end
end
