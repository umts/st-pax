class Passenger < ApplicationRecord
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: true

  scope :permanent, -> { where(permanent: true) }
  scope :temporary, -> { where(permanent: false) }
  scope :active, -> {where(active: true)}
  scope :expired, -> {where(expired: false)}

  def self.search(search)
    where("name LIKE ?", "%#{search}%")
  end

  def self.deactivate_expired_doc_note
    active.where("expiration < ?", 3.days.ago).each do |passenger|
      passenger.update_attributes active: false
    end
  end

  def will_expire_within_a_week?
    expiration.present? && expiration <= 7.days.since && expiration >= Date.today
  end
  def expired_within_3_days?
    expiration.present? && expiration >= 3.days.ago && expiration <= 1.days.ago
  end
end
