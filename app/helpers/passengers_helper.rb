# frozen_string_literal: true

module PassengersHelper
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

  def verification_source(verification)
    return if verification.nil?
    if verification.verification_source.needs_contact_info?
      render partial: 'contact_information', locals: { verification: verification }
    else
      verification.verification_source.name
    end
  end
end
