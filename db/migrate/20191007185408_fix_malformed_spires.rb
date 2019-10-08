class FixMalformedSpires < ActiveRecord::Migration[5.2]
  def change
    Passenger.all.each do |passenger|
      # check if their spires are just digits
      if passenger.spire.match?(/^\d{8}$/)
        # put in correct format, skipping validations
        correct_spire = passenger.spire + '@umass.edu'
        passenger.update_attribute(:spire, correct_spire)
      end
    end
  end
end
