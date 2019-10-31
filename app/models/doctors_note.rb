# frozen_string_literal: true

class DoctorsNote < ApplicationRecord
  belongs_to :passenger

  validates :passenger, uniqueness: true
  validate :temporary_passenger
  validates :expiration_date, presence: true
  validates :doctors_name, presence: { unless: -> { :skip_doctors_info } }
  validates :doctors_phone,
    presence: { unless: -> { :skip_doctors_info || doctors_address.blank? },
                message: "must be entered if doctor's address is blank" }
  validates :doctors_address,
    presence: { unless: -> { :skip_doctors_info || doctors_phone.blank? },
                message: "must be entered if doctor's phone number is blank" }

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
    return if passenger.temporary?

    errors.add :base, 'must belong to a temporary passenger'
  end
end
