# frozen_string_literal: true

require 'mock_github_client'

class Feedback
  include ActiveModel::Model

  attr_accessor :title, :description, :category, :issue

  CATEGORIES = %w[bug enhancement addition].freeze
  DEFAULT_CATEGORIES = %w[unconfirmed].freeze

  validates :title, presence: true
  validates :category, inclusion: { in: CATEGORIES }

  def self.repo
    Figaro.env.github_repo
  end

  def self.token
    Figaro.env.github_token
  end

  def submit!
    @issue =
      client.create_issue Feedback.repo, title, description, labels: labels
  end

  def load(issue_number)
    @issue = client.issue Feedback.repo, issue_number
    self.title = @issue.title
    self.description = @issue.body
    self.category = (@issue.labels.map(&:name) & Feedback::CATEGORIES).first
  end

  def client
    @client ||=
      if Feedback.token.present?
        Octokit::Client.new(access_token: Feedback.token)
      else
        MockGithubClient.new
      end
  end

  private

  def labels
    categories = Feedback::DEFAULT_CATEGORIES + [category]
    categories.join(',')
  end
end
