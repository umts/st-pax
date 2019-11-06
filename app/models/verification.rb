# frozen_string_literal: true

class Verification < ApplicationRecord
  belongs_to :passenger

  validates :passenger, uniqueness: true
  validate :temporary_passenger

  validates :expiration_date, presence: true

  def self.grace_period
    3.business_days.ago
  end

  def self.expiration_warning
    7.days.from_now.to_date
  end

  def will_expire_within_warning_period?
    expiration_date < Verification.expiration_warning &&
      expiration_date >= Date.today
  end

  def expired_within_grace_period?
    return false if expiration_date >= Time.zone.today
    expiration_date > Verification.grace_period
  end

  def expired?
    expiration_date < Verification.grace_period
  end

  private

  def temporary_passenger
    return if passenger.temporary?

    errors.add :base, 'must belong to a temporary passenger'
  end
end
