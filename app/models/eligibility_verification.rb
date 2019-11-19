# frozen_string_literal: true

class EligibilityVerification < ApplicationRecord
  belongs_to :passenger
  belongs_to :verifying_agency, optional: true

  # need this redundancy because of bootstrap validations
  validates :verifying_agency_id, presence: true

  validates :passenger, uniqueness: true

  validates :expiration_date, presence: true, if: :passenger_requires_validation
  validates :expiration_date,
    absence: { if: -> { passenger.permanent? },
               message: 'may not exist for a permanent passenger' }

  def self.grace_period
    3.business_days.ago
  end

  def self.expiration_warning
    7.days.from_now.to_date
  end

  def will_expire_within_warning_period?
    return false if expiration_date.blank?

    expiration_date < EligibilityVerification.expiration_warning &&
      expiration_date >= Date.today
  end

  def expired_within_grace_period?
    return false if expiration_date.blank? || expiration_date  >= Time.zone.today

    expiration_date > EligibilityVerification.grace_period
  end

  def expired?
    return false if expiration_date.blank?

    expiration_date < EligibilityVerification.grace_period
  end

  private

  def passenger_requires_validation
    passenger&.active? && passenger&.temporary?
  end
end
