# frozen_string_literal: true

module PassengersHelper
  def doctors_note_fields_class
    'hide-view' if @passenger.permanent?
  end

  def passengers_table_row_class(passenger)
    if passenger.doctors_note&.will_expire_within_warning_period?
      'expires-soon'
    elsif passenger.needs_doctors_note?
      'needs-note'
    elsif passenger.rides_expired?
      'expired'
    end
  end
end
