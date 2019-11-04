# frozen_string_literal: true

module PassengersHelper
  # this method is currently unused
  def doctors_information_fields_class
    'hide-view' if @passenger.permanent?
  end

  def passengers_table_row_class(passenger)
    if passenger.verification&.will_expire_within_warning_period?
      'expires-soon'
    elsif passenger.needs_verification?
      'needs-note'
    elsif passenger.rides_expired?
      'expired'
    end
  end

  def sortable_date(note)
    note.expiration_date.strftime('%Y%m%d') if note.present?
  end
end
