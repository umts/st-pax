# frozen_string_literal: true

class MockGithubClient
  MockIssue = Struct.new(:number, :title, :body, :labels) do
    def html_url = nil
  end

  MockLabel = Struct.new(:name)

  def initialize(logger: nil)
    @logger = logger || Rails.logger
  end

  def create_issue(repo, title, body, options = {})
    @logger.info <<~LOG
      GH Issue Submission
      -------------------
      Repo: #{repo}
      Title: #{title}
      Body:
      #{body.to_s.lines.map { |line| "  #{line}" }.join}
      Options: #{options.inspect}
    LOG
    dummy
  end

  def issue(_repo, _issue_number)
    dummy
  end

  private

  def dummy
    MockIssue.new(1, 'Dummy Issue', 'Issue description', [MockLabel.new('bug')])
  end
end
