class ReplaceRegisteredWithDisabilityServicesWithVerifyingAgency < ActiveRecord::Migration[5.2]
  def up
    Passenger.where(registered_with_disability_services: true).each do |passenger|
      agent = VerifyingAgency.find_by(name: 'Disability Services')
      if passenger.eligibility_verification.present?
        passenger.eligibility_verification.assign_attributes(
          verifying_agency_id: agent.id
        )
        passenger.eligibility_verification.save(validate: false)
      else
        verification = EligibilityVerification.new(
          passenger_id: passenger.id,
          verifying_agency_id: agent.id
        )
        verification.save(validate: false)
      end
    end
  end
  def down
    EligibilityVerification.joins(:verifying_agency).where(
      verifying_agencies: { name: 'Disability Services' }
    ).each do |verification|
      verification.assign_attributes(verifying_agency_id: nil)
      verification.save(validate: false)
      verification.passenger.assign_attributes(
        registered_with_disability_services: true
      )
      verification.passenger.save(validate: false)
    end
  end
end
