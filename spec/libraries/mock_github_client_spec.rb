# frozen_string_literal: true

require 'logger'
require 'pry'
require 'mock_github_client'

RSpec.describe MockGithubClient do
  let(:io) { StringIO.new }
  let(:client) { MockGithubClient.new(logger: Logger.new(io)) }
  let(:log) { io.rewind && io.read }

  describe '#create_issue' do
    let :call do
      client.create_issue 'acme/widgets',
                          'It broke',
                          "* This is broken\n*That is broken\n*Those are broken",
                          labels: 'bug,test'
    end

    it 'logs the would-be issue' do
      call
      expect(log).to match(/^Repo: acme\/widgets$/)
      expect(log).to match(/^Title: It broke$/)
      expect(log).to match(/^  \* This is broken$/)
      expect(log).to match(/^Options: {:labels=>"[^"]*"}$/)
    end

    it 'returns a dummy issue' do
      expect(call).to respond_to(:number, :title, :body, :labels)
      expect(call.labels).to be_an(Array)
      expect(call.labels.first).to respond_to(:name)
    end
  end
end
