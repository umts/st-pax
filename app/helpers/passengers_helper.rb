# frozen_string_literal: true

module PassengersHelper
  def doctors_note_row_class(note)
    if note.will_expire_within_warning_period?
      'will_expire_soon'
    elsif note.expired_within_grace_period?
      'expired_within_grace_period'
    elsif note.expired?
      'inactive'
    end
  end

  def passengers_table_row_class(passenger)
    return if passenger.permanent?
    return 'no_note' if passenger.doctors_note.blank?

    doctors_note_row_class(passenger.doctors_note)
  end

  def sortable_date(note)
    if note.present?
      note.expiration_date.strftime('%Y%m%d')
    end
  end
end
