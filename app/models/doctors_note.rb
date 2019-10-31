# frozen_string_literal: true

class DoctorsNote < ApplicationRecord
  belongs_to :passenger

  validates :passenger, uniqueness: true
  validate :temporary_passenger
  validates :expiration_date, presence: true
  validate :doctors_information

  def skip_doctors_info
    passenger.registered_with_disability_services?
  end

  def self.grace_period
    3.business_days.ago
  end

  def self.expiration_warning
    7.days.from_now.to_date
  end

  def will_expire_within_warning_period?
    expiration_date < DoctorsNote.expiration_warning &&
      expiration_date >= Date.today
  end

  def expired_within_grace_period?
    return false if expiration_date >= Time.zone.today
    expiration_date > DoctorsNote.grace_period
  end

  def expired?
    expiration_date < DoctorsNote.grace_period
  end

  private

  def temporary_passenger
    return if passenger&.temporary?

    errors.add :base, 'must belong to a temporary passenger'
  end

  def doctors_information
    return if passenger.registered_with_disability_services?
    errors.add(:doctors_name, 'must be present') if doctors_name.blank?
    if doctors_phone.blank? && doctors_address.blank?
      errors.add(
        :base, "either the doctor's phone number or address must be present."
      )
    end
  end

end
