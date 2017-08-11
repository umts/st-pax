class DoctorsNote < ApplicationRecord
  belongs_to :passenger

  before_save do
    assign_attributes(expiration_date: nil) if passenger.permanent?
  end

  def self.grace_period
    3.days.ago.to_date
  end

  def self.expiration_warning
    7.days.since.to_date
  end

  def self.deactivate_expired_doc_note
    active.where('expiration_date < ?', grace_period).each do |doctors_note|
      doctors_note.update_attributes active: false
    end
  end

  def will_expire_within_warning_period?
    expiration_date.present? &&
      expiration_date < DoctorsNote.expiration_warning &&
      expiration_date >= Date.today
  end

  def expired_within_grace_period?
    expiration_date.present? &&
      expiration_date < Date.today &&
      expiration_date >= DoctorsNote.grace_period
  end

  def expired?
    expiration_date.present? && expiration_date < DoctorsNote.grace_period
  end

  def temporary?
    !passenger.permanent?
  end
end
