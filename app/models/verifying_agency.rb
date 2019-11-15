# frozen_string_literal: true

class VerifyingAgency < ApplicationRecord
  has_many :eligibility_verifications

  validates :name, presence: true, uniqueness: true
end
