# frozen_string_literal: true

module FeedbackHelper
  def github_url
    "https://github.com/#{Feedback.repo}/issues"
  end
end
