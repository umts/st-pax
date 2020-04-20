# frozen_string_literal: true

require 'rails_helper'
require 'mock_github_client'

RSpec.describe Feedback do
  let(:client) { MockGithubClient.new(logger: Logger.new(nil)) }
  let(:feedback) { build :feedback }

  describe '#submit!' do
    let(:sig_pattern) { /^\[\d+\]\([^)]+\)$/ }
    let(:call) { feedback.submit! }
    before :each do
      allow(feedback).to receive(:client).and_return(client)
    end

    it 'creates an issue' do
      expect(client).to receive(:create_issue).with(
        anything,
        feedback.title,
        feedback.description,
        hash_including(labels: /#{feedback.category}/)
      )
      call
    end

    it 'signs the feedback if the user is set' do
      expect(client).to receive(:create_issue).with(
        anything, anything, sig_pattern, any_args
      )
      feedback.user = create :user
      call
    end
  end

  describe '#load' do
    let(:call) { feedback.load(1) }
    before :each do
      allow(feedback).to receive(:client).and_return(client)
    end

    it 'loads the issue from GitHub' do
      expect(client).to receive(:issue)
        .with(anything, 1).and_call_original
      call
    end

    it 'sets the title from the issue' do
      call
      expect(feedback.title).to eq 'Dummy Issue'
    end

    it 'sets the description from the issue' do
      call
      expect(feedback.description).to eq 'Issue description'
    end

    it 'sets the category based on the issue labels' do
      call
      expect(feedback.category).to eq 'bug'
    end
  end

  describe '#client' do
    let(:call) { feedback.client }

    it 'is a mock client if there is no token' do
      allow(Feedback).to receive(:token).and_return(nil)
      expect(call).to be_a(MockGithubClient)
    end

    it 'is an Octokit::Client if there is a token' do
      allow(Feedback).to receive(:token)
        .and_return 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeef'
      expect(call).to be_a(Octokit::Client)
    end
  end
end
