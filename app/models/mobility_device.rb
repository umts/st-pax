# frozen_string_literal: true

class MobilityDevice < ApplicationRecord
  validates :device, presence: true, uniqueness: true
end
