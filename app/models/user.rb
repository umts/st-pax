# frozen_string_literal: true

class User < ApplicationRecord
  has_many :log_entries, dependent: :restrict_with_error

  validates :name, :spire, presence: true

  scope :admins, -> { where admin: true }
  scope :dispatchers, -> { where.not admin: true }
  scope :active, -> { where active: true }

  def can_delete?(item)
    admin? || (item.is_a?(LogEntry) && item.user == self)
  end

  def dispatcher?
    !admin?
  end
end
