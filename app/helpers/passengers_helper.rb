# frozen_string_literal: true

module PassengersHelper
  def verifying_agency_label(dispatcher)
    return 'Which agency verifies that this passenger needs rides?' if dispatcher

    'Which agency verifies that you need our service?'
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

  def status_action_button(passenger, current_status)
    settings = {
      nil => { text: 'Archive', status: 'archived', btn: 'warning' },
      :archived => { text: 'Reactivate', status: 'active', btn: 'warning' },
      :pending => { text: 'Confirm Registration', status: 'active', btn: 'success' }
    }[current_status]

    button_to settings[:text],
              set_status_passenger_path(passenger, status: settings[:status]),
              class: "btn btn-#{settings[:btn]}"
  end
end
