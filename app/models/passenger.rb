# frozen_string_literal: true

class Passenger < ApplicationRecord
  belongs_to :registerer, foreign_key: :registered_by, class_name: 'User',
                          optional: true
  has_one :eligibility_verification, dependent: :destroy
  accepts_nested_attributes_for :eligibility_verification
  belongs_to :mobility_device, optional: true
  belongs_to :carrier, optional: true

  validates :registration_status, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :registration_date, :phone, :address, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :spire, uniqueness: { case_sensitive: false },
                    format: { with: /\A\d{8}@umass.edu\z/ }
  validates :eligibility_verification, presence: { if: -> { requires_verification? } }
  validates :carrier_id, presence: true, if: :subscribed_to_sms?

  enum registration_status: { pending: 0, active: 1, archived: 2 }

  scope :permanent, -> { where(permanent: true) }
  scope :temporary, -> { where.not(permanent: true) }

  before_validation :assign_registration_date

  after_commit do
    PassengerMailer.notify_archived(self).deliver_now if saved_change_to_registration_status? && archived?
    PassengerMailer.notify_active(self).deliver_now if saved_change_to_registration_status? && active?
  end

  after_commit on: :create do
    PassengerMailer.notify_pending(self).deliver_now if pending?
  end

  def expiration_display
    return if permanent?

    eligibility_verification.try(:expiration_date).try(:strftime, '%m/%d/%Y') ||
      'No verification'
  end

  def needs_longer_rides?
    mobility_device&.needs_longer_rides?.present?
  end

  def needs_verification?
    return false if permanent?

    eligibility_verification&.expired_within_grace_period? ||
      (eligibility_verification.blank? && recently_registered?)
  end

  def recently_registered?
    registration_date >= 3.business_days.ago
  end

  def rides_expired?
    return false if permanent?

    grace_period = EligibilityVerification.grace_period
    registration_expired = registration_date < grace_period
    registration_expired && (eligibility_verification.nil? ||
                             eligibility_verification.expired?)
  end

  def rides_expire
    return if permanent?

    return 3.business_days.since(registration_date) if pending? && persisted?
    if eligibility_verification&.expiration_date.present?
      return 3.business_days.after(eligibility_verification.expiration_date)
    end
    return 3.business_days.after(registration_date) if persisted?

    3.business_days.after(Time.zone.today)
  end

  def temporary?
    !permanent?
  end

  def set_status(desired_status)
    # skip validations on archival
    if desired_status == 'archived'
      update_attribute(:registration_status, 'archived')
    else
      self.registration_status = desired_status
      save
    end
  end

  def permanent_or_temporary
    permanent? ? 'permanent' : 'temporary'
  end

  private

  def requires_verification?
    temporary? && active?
  end

  def assign_registration_date
    if registration_status_changed? && active?
      assign_attributes(registration_date: Time.zone.today)
    elsif registration_date.blank?
      assign_attributes(registration_date: (created_at || Time.zone.today))
    end
  end
end
