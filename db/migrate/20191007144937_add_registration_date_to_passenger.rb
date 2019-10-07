class AddRegistrationDateToPassenger < ActiveRecord::Migration[5.2]
  def change
    add_column :passengers, :registration_date, :date
  end
end
