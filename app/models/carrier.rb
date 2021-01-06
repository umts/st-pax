# frozen_string_literal: true

class Carrier < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :gateway_address, presence: true,
                              uniqueness: { case_sensitive: false }
  validates_format_of :gateway_address,
                      with: /\A@([^@\s]+\.)+[^@\s]+\z/,
                      message: 'must begin with @ and be followed by a name and domain'
  has_many :passengers
end
