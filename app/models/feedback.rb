# frozen_string_literal: true

require 'mock_github_client'

class Feedback
  include ActiveModel::Model

  attr_accessor :title, :description, :category, :issue, :user

  CATEGORIES = %w[bug enhancement addition].freeze
  DEFAULT_CATEGORIES = %w[unconfirmed].freeze

  validates :title, presence: true
  validates :category, inclusion: { in: CATEGORIES }

  def self.repo
    Rails.application.credentials.dig(:github, :repo)
  end

  def submit!
    @issue = client.create_issue Feedback.repo, title, signed_description, labels:
  end

  def load(issue_number)
    @issue = client.issue Feedback.repo, issue_number
    self.title = @issue.title
    self.description = @issue.body
    self.category = (@issue.labels.map(&:name) & Feedback::CATEGORIES).first
    self
  end

  def client
    @client ||=
      if IssueToken.token.present?
        Octokit::Client.new(access_token: IssueToken.token)
      else
        MockGithubClient.new
      end
  end

  private

  def labels
    categories = Feedback::DEFAULT_CATEGORIES + [category]
    categories.join(',')
  end

  def signed_description
    return description if user.blank?

    "#{description}\n\n[#{user.id}](#{user.url})"
  end
end
