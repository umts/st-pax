# frozen_string_literal: true

class Passenger < ApplicationRecord
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  STATUSES = %w[Alumni Faculty Staff Student].freeze
  validates :status, inclusion: { in: STATUSES, allow_blank: true }
  validates :spire,
            format: { with: /\A\d{8}@umass.edu\z/,
                      message: 'must be 8 digits followed by @umass.edu' }

  belongs_to :registerer, foreign_key: :registered_by, class_name: 'User',
                          optional: true

  enum active_status: { pending: 0, active: 1, archived: 2 }

  scope :permanent, -> { where(permanent: true) }
  scope :temporary, -> { where.not(permanent: true) }

  has_one :doctors_note, dependent: :destroy
  accepts_nested_attributes_for :doctors_note

  belongs_to :mobility_device, optional: true

  def expiration_display
    return if permanent?

    doctors_note.try(:expiration_date).try :strftime, '%m/%d/%Y' || 'No Note'
  end

  def temporary?
    !permanent?
  end
end
