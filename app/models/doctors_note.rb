# frozen_string_literal: true

class DoctorsNote < ApplicationRecord
  belongs_to :passenger
  validates :passenger, uniqueness: true
  validate :temporary_passenger

  validates :expiration_date, presence: true

  def self.grace_period
    3.days.ago.to_date
  end

  def self.expiration_warning
    7.days.since.to_date
  end

  def will_expire_within_warning_period?
    expiration_date < DoctorsNote.expiration_warning && expiration_date >= Date.today
  end

  def expired_within_grace_period?
    expiration_date < Date.today && expiration_date >= DoctorsNote.grace_period
  end

  def expired?
    expiration_date < DoctorsNote.grace_period
  end

  private

  def temporary_passenger
    if passenger.permanent?
      errors.add :base, 'must belong to a temporary passenger'
    end
  end
end
