# frozen_string_literal: true

class User < ApplicationRecord
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
