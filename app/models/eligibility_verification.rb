# frozen_string_literal: true

class EligibilityVerification < ApplicationRecord
  belongs_to :passenger
  # belongs_to set to optional true with presence validation in order to
  # make bootstrap validations work nicely.
  belongs_to :verifying_agency, optional: true

  validates :passenger, uniqueness: true
  validates :expiration_date, presence: true, if: :passenger_requires_validation
  validates :verifying_agency_id, presence: true, if: :passenger_requires_validation
  validates :expiration_date, absence: { if: -> { verifying_agency.blank? }, message: :no_agency }
  validates :expiration_date, absence: { if: -> { passenger&.permanent? }, message: :perm_pax }
  validates :name, presence: { if: -> { verifying_agency&.needs_contact_info? } }
  validates :address, presence: { if: -> { phone.blank? && verifying_agency&.needs_contact_info? } }
  validates :phone, presence: { if: -> { address.blank? && verifying_agency&.needs_contact_info? } }

  before_save :reset_contact_info

  def self.grace_period
    3.business_days.ago
  end

  def self.expiration_warning
    7.days.from_now.to_date
  end

  def will_expire_within_warning_period?
    return false if expiration_date.blank?

    expiration_date < EligibilityVerification.expiration_warning &&
      expiration_date >= Time.zone.today
  end

  def expired_within_grace_period?
    return true if expiration_date.blank?
    return false if expiration_date >= Time.zone.today

    expiration_date > EligibilityVerification.grace_period
  end

  def expired?
    date = expiration_date || passenger.registration_date

    date < EligibilityVerification.grace_period
  end

  private

  def passenger_requires_validation
    passenger&.active? && passenger&.temporary?
  end

  def reset_contact_info
    return if verifying_agency&.needs_contact_info?

    assign_attributes name: nil, address: nil, phone: nil
  end
end
