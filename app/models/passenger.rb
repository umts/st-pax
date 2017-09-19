# frozen_string_literal: true

class Passenger < ApplicationRecord
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  STATUSES = %w[Alumni Faculty Staff Student].freeze
  validates :status, inclusion: { in: STATUSES, allow_blank: true }
  validates :spire,
            format: { with: /\A\d{8}@umass.edu\z/,
                      message: 'must be 8 digits followed by @umass.edu',
                      allow_blank: true }

  belongs_to :registerer, foreign_key: :registered_by, class_name: 'User',
                          optional: true

  scope :permanent, -> { where(permanent: true) }
  scope :temporary, -> { where(permanent: false) }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

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

  def self.deactivate_expired_doc_note
    expired = active.joins(:doctors_note)
                    .where('doctors_notes.expiration_date < ?',
                           DoctorsNote.grace_period)
    expired.each do |passenger|
      passenger.update_attributes active: false
    end
  end
end
