# frozen_string_literal: true

module PassengersHelper
  def passengers_table_row_class(passenger)
    if passenger.eligibility_verification&.will_expire_within_warning_period?
      'expires-soon'
    elsif passenger.needs_verification?
      'needs-verification'
    elsif passenger.rides_expired?
      'expired'
    end
  end

  def verification_information(passenger)
    agency = passenger.eligibility_verification&.verifying_agency
    if agency&.needs_contact_info?
      render partial: 'contact_information',
        locals: { verification: passenger.eligibility_verification }
    else
      agency&.name ||
        'No agency has verified that this passenger requires rides.'
    end
  end
end
