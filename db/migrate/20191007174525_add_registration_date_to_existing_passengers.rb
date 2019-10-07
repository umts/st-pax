class AddRegistrationDateToExistingPassengers < ActiveRecord::Migration[5.2]
  def change
    Passenger.all.each { |p| p.update(registration_date: p.created_at) }
  end
end
