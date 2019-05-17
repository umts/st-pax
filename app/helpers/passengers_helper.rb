# frozen_string_literal: true

module PassengersHelper
  def doctors_note_row_class(note)
    if note.override_expiration?
      'overridden'
    elsif note.will_expire_within_warning_period?
      'will_expire_soon'
    elsif note.expired_within_grace_period?
      'expired_within_grace_period'
    elsif note.expired?
      'inactive'
    end
  end

  def passengers_table_row_class(passenger)
    return 'inactive' unless passenger.active?
    return if passenger.permanent?
    return 'no_note' if passenger.doctors_note.blank?

    doctors_note_row_class(passenger.doctors_note)
  end

  def passengers_table_class
    if @current_user.admin?
      'row-border admin-table'
    else
      'row-border dispatch-table'
    end
  end

  def hide_form_class
    'hide_view' unless @doctors_note.override_expiration?
  end
end
