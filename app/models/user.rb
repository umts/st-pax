class User < ApplicationRecord
  validates :name, :email, :spire, presence: true

  scope :dispatchers, -> { where.not admin: true }

  def dispatcher?
    !admin?
  end
end
