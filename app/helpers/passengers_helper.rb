# frozen_string_literal: true

module PassengersHelper
  def doctors_note_fields_class
    'hide-view' if @passenger.permanent?
  end

  def passengers_table_row_class(passenger)
    return if passenger.permanent?
    if passenger.doctors_note.try(:will_expire_within_warning_period?)
      'expires-soon'
    elsif passenger.needs_doctors_note?
      'needs-note'
    elsif passenger.doctors_note.try(:expired?)
      'expired'
    end
  end

  def sortable_date(note)
    note.expiration_date.strftime('%Y%m%d') if note.present?
  end
end
