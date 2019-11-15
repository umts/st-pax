# frozen_string_literal: true

class Passenger < ApplicationRecord
  validates :active_status, presence: true
  validates :name,  presence: true, length: { maximum: 50 }
  validates :registration_date, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  STATUSES = %w[Alumni Faculty Staff Student].freeze
  validates :status, inclusion: { in: STATUSES, allow_blank: true }
  validates :spire, uniqueness: true,
            format: { with: /\A\d{8}@umass.edu\z/,
                      message: 'must be 8 digits followed by @umass.edu' }
  validates :eligibility_verification,
    presence: { if: -> { needs_verification? },
                message:  ' required for temporary passengers' }

  belongs_to :registerer, foreign_key: :registered_by, class_name: 'User',
                          optional: true

  enum active_status: { pending: 0, active: 1, archived: 2 }

  scope :permanent, -> { where(permanent: true) }
  scope :temporary, -> { where.not(permanent: true) }

  has_one :eligibility_verification, dependent: :destroy
  accepts_nested_attributes_for :eligibility_verification

  belongs_to :mobility_device, optional: true

  before_validation :assign_registration_date

  def expiration_display
    return if permanent?

    eligibility_verification.try(:expiration_date).try :strftime, '%m/%d/%Y' || 'No Note'
  end

  def needs_longer_rides?
    mobility_device&.needs_longer_rides?.present?
  end

  def needs_verification?
    return false if permanent?

    recently_registered = registration_date >= 3.business_days.ago
    eligibility_verification&.expired_within_grace_period? ||
    (eligibility_verification.blank? && recently_registered)
  end

  def rides_expired?
    return false if permanent?

    registration_expired = registration_date < Verification.grace_period
    registration_expired && (eligibility_verification.nil? || eligibility_verification.expired?)
  end

  def rides_expire
    return if permanent?

    if eligibility_verification&.expiration_date.present?
      return 3.business_days.after(eligibility_verification.expiration_date)
    end
    return 3.business_days.since(registration_date) if persisted?

    3.business_days.from_now
  end

  def temporary?
    !permanent?
  end

  def permanent_or_temporary
    permanent? ? 'permanent' : 'temporary'
  end

  private

  def assign_registration_date
    if active_status_changed? && active?
      assign_attributes(registration_date: Time.zone.today)
    elsif registration_date.blank?
      assign_attributes(registration_date: (created_at || Time.zone.today))
    end
  end
end
