# frozen_string_literal: true

class GithubController < ApplicationController
  before_action :restrict_to_admin

  def callback
    token = Octokit.exchange_code_for_token(
      params[:code],
      Rails.application.credentials.dig(:github, :client_id),
      Rails.application.credentials.dig(:github, :client_secret)
    )[:access_token]

    IssueToken.instance.update(token: token)

    redirect_to root_path
  end
end
