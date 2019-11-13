class ReplaceRegisteredWithDisabilityServicesWithVerificationSource < ActiveRecord::Migration[5.2]
  def up
    Passenger.where(registered_with_disability_services: true).each do |passenger|
      source = VerificationSource.find_by(name: 'Disability Services')
      if passenger.verification.present?
        passenger.verification.assign_attributes(
          verification_source_id: source.id
        )
        passenger.verification.save(validate: false)
      else
        verification = Verification.new(
          passenger_id: passenger.id,
          verification_source_id: source.id
        )
        verification.save(validate: false)
      end
    end
  end
  
  def down
    Verification.joins(:verification_source).where(
      verification_source: { name: 'Disability Services' }
    ).each do |verification|
      verification.assign_attributes(verification_source_id: nil)
      verification.save(validate: false)
    end
  end
end
