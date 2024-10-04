# frozen_string_literal: true
require 'uri'

module GithubHelper
  def github_login_url
    client_id = Rails.application.credentials.dig(:github, :client_id)
    if client_id.present?
      URI.parse('https://github.com/login/oauth/authorize').tap do |uri|
        uri.query = URI.encode_www_form(client_id:, scope: 'repo')
      end.to_s
    else
      '#'
    end
  end
end
