class User < ApplicationRecord
  validates :name, :email, :spire, presence: true

  def dispatcher?
    !admin?
  end
end
