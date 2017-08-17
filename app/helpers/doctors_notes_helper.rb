module DoctorsNotesHelper

  def expiration_check(doctors_note)
    if doctors_note.will_expire_within_warning_period?
      'will_expire_soon'
    elsif doctors_note.expired_within_grace_period?
      'expired_within_grace_period'
    elsif doctors_note.expired?
      'inactive'
    elsif doctors_note.passenger.temporary? && doctors_note.expiration_date.blank?
      'no_note'
    end
  end
end
