# frozen_string_literal: true

module PassengersHelper
  def verifying_agency_help_text
    'Required only for temporary passengers.'
  end

  def registration_header
    return 'New Passenger' if @current_user.present?

    'Register for Special Transportation'
  end

  def verifying_agency_label
    return 'Which agency verifies that this passenger needs rides?' if @current_user.present?

    'Which agency verifies that you need our service?'
  end

  def expiration_date_label
    subject = if @current_user.present?
                'the passenger'
              else 'you'
              end
    "How long will #{subject} be with us?"
  end

  def passengers_table_row_class(passenger)
    if passenger.eligibility_verification&.will_expire_within_warning_period?
      'expires-soon'
    elsif passenger.needs_verification?
      'needs-note'
    elsif passenger.rides_expired?
      'expired'
    end
  end

  def contact_information_class(verification)
    needs_contact_info = verification&.verifying_agency&.needs_contact_info?
    classes = ['contact-information']
    classes << 'hide-view' unless needs_contact_info
    classes
  end

  def verification_information(passenger)
    agency = passenger.eligibility_verification&.verifying_agency
    if agency&.needs_contact_info?
      render partial: 'verifying_agency_contact_info',
             locals: { verification: passenger.eligibility_verification }
    else
      agency&.name ||
        'No agency has verified that this passenger requires rides.'
    end
  end
end
