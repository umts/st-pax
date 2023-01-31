class IssueToken < ApplicationRecord
  validates :singleton, inclusion: { in: [0] }, uniqueness: true
  validate :functioning_token

  class << self
    delegate :token, to: :instance

    def instance
      create_with(singleton: 0).first_or_create
    end
  end

  private

  def functioning_token
    return if token.blank?

    client = Octokit::Client.new client_id: Rails.application.credentials.dig(:github, :client_id),
                                 client_secret: Rails.application.credentials.dig(:github, :client_secret)
    client.check_application_authorization token
  rescue Octokit::NotFound
    errors.add :token, 'is not valid or is not authorized'
  end
end
