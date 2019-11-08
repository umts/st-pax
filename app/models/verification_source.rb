# frozen_string_literal: true

class VerificationSource < ApplicationRecord
  has_many :verifications

  validates :name, presence: true, uniqueness: true
end
