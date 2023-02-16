# frozen_string_literal: true

module GithubHelper
  def github_login_url
    client_id = Rails.application.credentials.dig(:github, :client_id)
    client_id.present? ? Octokit.client.authorize_url(client_id, scope: 'repo') : '#'
  end
end
