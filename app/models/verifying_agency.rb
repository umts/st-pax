# frozen_string_literal: true

class VerifyingAgency < ApplicationRecord
  has_many :eligibility_verifications, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
end
