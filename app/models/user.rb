# frozen_string_literal: true

class User < ApplicationRecord
  has_many :log_entries, dependent: :restrict_with_error

  validates :name, :spire, presence: true
  validates :spire,
            format: { with: /\A\d{8}@umass.edu\z/,
                      message: 'must be 8 digits followed by @umass.edu' }

  scope :admins, -> { where admin: true }
  scope :dispatchers, -> { where.not admin: true }
  scope :active, -> { where active: true }

  def can_modify?(item)
    admin? || (item.is_a?(LogEntry) && item.user == self)
  end

  def dispatcher?
    !admin?
  end

  def url
    url_options = Rails.application.config.action_mailer.default_url_options
    Rails.application.routes.url_helpers.user_url self, url_options
  end
end
