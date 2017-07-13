module IndexHelper

  def expiration_check(passenger)
    if passenger.will_expire_within_warning_period?
      'will_expire_soon'
    elsif passenger.expired_within_grace_period?
      'expired_within_grace_period'
    elsif passenger.expired?
      'inactive'
    elsif passenger.temporary? && passenger.expiration.blank?
      'no_note'
    end
  end

  def table_class
    if @current_user.admin?
      'row-border admin-table'
    else
      'row-border dispatch-table'
    end
  end

end
