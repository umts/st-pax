# frozen_string_literal: true

module PassengersHelper
  def verifying_agency_help_text
    'Required only for temporary passengers.'
  end

  def registration_header
    return 'New Passenger' if Current.user.present?

    "Register for #{t 'department.name'}"
  end

  def verifying_agency_label
    return 'Which agency verifies that this passenger needs rides?' if Current.user.present?

    'Which agency verifies that you need our service?'
  end

  def expiration_date_label
    subject = Current.user.present? ? 'the passenger' : 'you'
    "How long will #{subject} be with us?"
  end

  def passengers_table_row_class(passenger)
    return if passenger.archived?

    if passenger.eligibility_verification&.will_expire_within_warning_period?
      'expires-soon'
    elsif passenger.needs_verification?
      'needs-note'
    elsif passenger.rides_expired?
      'expired'
    end
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

  def expiration_date_help_text(passenger)
    if passenger.eligibility_verification.blank? && passenger.temporary?
      "Rides expire #{passenger.rides_expire.try(:strftime, '%m/%d/%Y')}"
    else
      ''
    end
  end

  def status_action_button(passenger, current_status)
    settings = status_action_settings current_status

    button_to settings[:text],
              set_status_passenger_path(passenger, status: settings[:status]),
              class: "btn btn-#{settings[:btn]}"
  end

  def status_action_settings(current_status)
    {
      nil => { text: 'Archive', status: 'archived', btn: 'warning' },
      :archived => { text: 'Reactivate', status: 'active', btn: 'warning' },
      :pending => { text: 'Confirm Registration', status: 'active', btn: 'success' }
    }.fetch(current_status)
  end
end
