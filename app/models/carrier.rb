class Carrier < ApplicationRecord
  validates :name, presence: true
  validates :gateway_address, presence: true
  has_many :passengers
end
