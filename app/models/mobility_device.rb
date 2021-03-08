# frozen_string_literal: true

class MobilityDevice < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :passengers, dependent: :restrict_with_error
end
