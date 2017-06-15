class User < ApplicationRecord
  validates :name, :email, :spire, presence: true
end
