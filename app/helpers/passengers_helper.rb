# frozen_string_literal: true

module PassengersHelper
  def verification_fields_class
    'hide-view' if @passenger.permanent?
  end

  def passengers_table_row_class(passenger)
    if passenger.verification&.will_expire_within_warning_period?
      'expires-soon'
    elsif passenger.needs_verification?
      'needs-verification'
    elsif passenger.rides_expired?
      'expired'
    end
  end

  def sortable_date(verification)
    verification.try(:expiration_date).try(:strftime, '%Y%m%d')
  end
end
