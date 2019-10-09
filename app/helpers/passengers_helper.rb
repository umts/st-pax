# frozen_string_literal: true

module PassengersHelper
  def doctors_note_row_class(note)
    if note.blank?
      'no_note'
    elsif note.will_expire_within_warning_period?
      'will_expire_soon'
    elsif note.expired_within_grace_period?
      'expired_within_grace_period'
    elsif note.expired?
      'inactive'
    end
  end

  def mobility_device(device)
    if device.try(:needs_longer_rides) == true
      'longer_ride'
    end
  end

  def passengers_table_row_class(passenger)
    if passenger.permanent? && mobility_device(passenger.mobility_device).present?
        'longer_ride'
    else
      doc_note = doctors_note_row_class(passenger.doctors_note)
      if mobility_device(passenger.mobility_device).present?
        doc_note.to_s + 'longer_ride'
      else
        doc_note.to_s
      end
    end
  end



  def sortable_date(note)
    if note.present?
      note.expiration_date.strftime('%Y%m%d')
    end
  end
end
