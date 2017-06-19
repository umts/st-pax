module PassengersHelper
  def expiration_check(passenger)
    if passenger.will_expire_within_a_week?
      'will_expire_soon'
    elsif passenger.expired_within_grace_period?
      'expired_within_grace_period'
    elsif passenger.expired_for_3_days?
      'expired_for_3_days'
    elsif passenger.temporary? && passenger.expiration.blank?
      'no_note'
    end
  end
end
