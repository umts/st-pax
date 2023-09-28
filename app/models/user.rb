# frozen_string_literal: true

class User < ApplicationRecord
  has_many :log_entries, dependent: :restrict_with_error
  has_many :registered_passengers, inverse_of: :registerer, foreign_key: :registered_by, class_name: 'Passenger'

  validates :name, :spire, presence: true
  validates :spire, uniqueness: { case_sensitive: false }, format: { with: /\A\d{8}@umass.edu\z/ }

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
