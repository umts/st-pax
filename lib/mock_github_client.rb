# frozen_string_literal: true

require 'ostruct'

class MockGithubClient
  def initialize(logger: nil)
    @logger = logger || Rails.logger
  end

  def create_issue(repo, title, body, options = {})
    @logger.info <<~LOG
      GH Issue Sumbission
      -------------------
      Repo: #{repo}
      Title: #{title}
      Body:
      #{body.to_s.lines.map { |line| '  ' + line }.join('')}
      Options: #{options.inspect}
    LOG
    dummy
  end

  def issue(_repo, _issue_number)
    dummy
  end

  private

  def dummy
    OpenStruct.new(
      number: 1,
      title: 'Dummy Issue',
      body: 'Issue description',
      labels: [OpenStruct.new(name: 'bug')]
    )
  end
end
