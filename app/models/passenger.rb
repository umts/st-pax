class Passenger < ApplicationRecord
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: true

  scope :permanent, -> { where(permanent: true) }
  scope :temporary, -> { where(permanent: false) }
  scope :active, -> {where(active: true)}
  scope :expired, -> {where(active: false)}

  def self.grace_period
    3.days.ago.to_date
  end
  def self.expiration_warning
    7.days.since.to_date
  end

  def self.deactivate_expired_doc_note
    active.where("expiration < ?", grace_period).each do |passenger|
      passenger.update_attributes active: false
    end
  end

  def will_expire_within_warning_period?
    expiration.present? && expiration < Passenger.expiration_warning && expiration >= Date.today
  end

  def expired_within_grace_period?
    expiration.present? && expiration < Date.today && expiration >= Passenger.grace_period
  end

  def expired?
    expiration.present? && expiration < Passenger.grace_period
  end

  def expiration_display
    if permanent?
      "None"
    else
      if expiration.present?
        expiration.strftime "%m/%d/%Y"
      else
        "No Note"
      end
    end
  end

  def temporary?
    !permanent?
  end
end
