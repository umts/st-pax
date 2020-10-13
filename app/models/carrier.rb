class Carrier < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :gateway_address, presence: true,
                              uniqueness: { case_sensitive: false }
  has_many :passengers
end
