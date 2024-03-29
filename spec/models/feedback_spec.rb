# frozen_string_literal: true

require 'rails_helper'
require 'mock_github_client'

RSpec.describe Feedback do
  let(:client) { MockGithubClient.new(logger: Logger.new(nil)) }
  let(:feedback) { build(:feedback) }

  describe '#submit!' do
    let(:sig_pattern) { /^\[\d+\]\([^)]+\)$/ }
    let(:call) { feedback.submit! }

    before do
      allow(feedback).to receive(:client).and_return(client)
      allow(client).to receive(:create_issue)
    end

    it 'creates an issue' do
      call
      expect(client).to have_received(:create_issue)
        .with(anything, feedback.title, feedback.description, hash_including(labels: /#{feedback.category}/))
    end

    it 'signs the feedback if the user is set' do
      feedback.user = create :user
      call
      expect(client).to have_received(:create_issue).with(anything, anything, sig_pattern, any_args)
    end
  end

  describe '#load' do
    let(:call) { feedback.load(1) }

    before do
      allow(feedback).to receive(:client).and_return(client)
      allow(client).to receive(:issue).and_call_original
    end

    it 'loads the issue from GitHub' do
      call
      expect(client).to have_received(:issue).with(anything, 1)
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
      allow(IssueToken).to receive(:token).and_return(nil)
      expect(call).to be_a(MockGithubClient)
    end

    it 'is an Octokit::Client if there is a token' do
      allow(IssueToken).to receive(:token)
        .and_return 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeef'
      expect(call).to be_a(Octokit::Client)
    end
  end
end
