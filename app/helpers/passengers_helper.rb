module PassengersHelper
  def expiration_check(passenger)
    if passenger.will_expire_within_a_week?
      'will_expire_soon'
    elsif passenger.expired_within_3_days?
      'expired_3_days'
    end
  end
end
