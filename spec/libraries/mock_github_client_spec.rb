# frozen_string_literal: true

require 'logger'
require 'mock_github_client'

RSpec.describe MockGithubClient do
  let(:io) { StringIO.new }
  let(:client) { described_class.new(logger: Logger.new(io)) }
  let(:log) { io.rewind && io.read }

  describe '#create_issue' do
    subject :call do
      client.create_issue 'acme/widgets',
                          'It broke',
                          "* This is broken\n*That is broken\n",
                          labels: 'bug,test'
    end

    it 'logs the would-be issue' do
      call
      expect(log).to(match(%r{^Repo: acme/widgets$})
                     .and(match(/^Title: It broke$/))
                     .and(match(/^  \* This is broken$/))
                     .and(match(/^Options: {labels: "[^"]*"}$/)))
    end

    it 'returns a dummy issue' do
      expect(call).to respond_to(:number, :title, :body, :labels)
    end

    it 'returns a dummy issue with labels' do
      expect(call.labels).to be_an(Array)
    end

    it 'returns dummy labels' do
      expect(call.labels.first).to respond_to(:name)
    end
  end
end
