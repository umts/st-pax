# frozen_string_literal: true

class Verification < ApplicationRecord
  belongs_to :passenger

  validates :passenger, uniqueness: true
  validate :temporary_passenger
  validates :expiration_date, presence: true
  validate :doctors_information
  validates :doctors_name,
    presence: true,
    if: :needs_doctors_information?

  enum source: {
    'UHS': 0,
    'Disability Services': 1,
    'Accessible Workplace': 2,
    'Other': 3
  }

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
    return if passenger&.temporary?

    errors.add :base, 'must belong to a temporary passenger'
  end

  def needs_doctors_information?
    source == 'Other'
  end

  def doctors_information
    return unless needs_doctors_information?
    error_message = 'If not registered with disability services, ' \
      'UHS, or Accessible Workplace, '
    if doctors_phone.blank? && doctors_address.blank?
      error_message += "either the doctor's phone or address must be present"
      errors.add(
        :base, error_message
      )
    end
  end
end
