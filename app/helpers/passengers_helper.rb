# frozen_string_literal: true

module PassengersHelper
  def passengers_table_row_class(passenger)
    return 'inactive' unless passenger.active?
    return if passenger.permanent?
    note = passenger.doctors_note
    if note.present?
      if note.override_expiration?
        'overridden'
      elsif note.will_expire_within_warning_period?
        'will_expire_soon'
      elsif note.expired_within_grace_period?
        'expired_within_grace_period'
      elsif note.expired?
        'inactive'
      end
    else 'no_note'
    end
  end

  def passengers_table_class
    if @current_user.admin?
      'row-border admin-table'
    else
      'row-border dispatch-table'
    end
  end

  def passengers_form
    if @doctors_note.override_expiration == false
      'hide_view'
    end
  end
end
