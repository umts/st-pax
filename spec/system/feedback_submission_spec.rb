# frozen_string_literal: true

require 'rails_helper'
require 'mock_github_client'

RSpec.describe 'Feedback Submission' do
  let(:title) { 'The site is broken' }
  let(:client) { MockGithubClient.new(logger: Logger.new(nil)) }
  let(:issue) { client.issue('repo', -999) }
  let(:sig_pattern) { /^\[\d+\]\([^)]+\)$/ }

  context 'without an IssueToken' do
    context 'when the user is a non-admin' do
      before do
        when_current_user_is :anyone
        visit new_feedback_path
      end

      it 'lets you know about the missing token' do
        expect(page).to have_text "site isn't configured"
      end

      it "Doesn't provide any further steps" do
        expect(page).to have_no_link 'authenticate with GitHub'
      end
    end

    context 'when the user is an admin' do
      before do
        when_current_user_is :admin
        visit new_feedback_path
      end

      it 'lets you know about the missing token' do
        expect(page).to have_text "site isn't configured"
      end

      it 'Provides a link to authorize the application' do
        expect(page).to have_link 'authenticate with GitHub'
      end
    end
  end

  context 'with an IssueToken' do
    before do
      allow(IssueToken).to receive(:usable?).and_return true
      allow(MockGithubClient).to receive(:new).and_return client
      allow(client).to receive(:create_issue).and_call_original

      when_current_user_is :anyone
      visit new_feedback_path
    end

    it 'renders the form again if feedback is invalid' do
      click_on 'Submit'
      expect(page).to have_text('New Feedback').and(have_text("Title can't be blank"))
    end

    it 'submits the feedback' do
      fill_in 'Title', with: title
      click_on 'Submit'

      expect(client).to have_received(:create_issue).with(anything, title, sig_pattern, hash_including(:labels))
    end

    it 'redirects back if submission fails' do
      allow(client).to receive(:create_issue).and_raise(Octokit::Error)
      fill_in 'Title', with: title
      click_on 'Submit'

      expect(page).to have_text('New Feedback').and(have_text('external error occurred'))
    end

    it 'goes to the GitHub content page if submission succeeds' do
      fill_in 'Title', with: title
      click_on 'Submit'

      expect(page).to have_current_path(feedback_path(1))
    end

    it 'displays the GitHub content if submission succeeds' do
      fill_in 'Title', with: title
      click_on 'Submit'

      expect(page).to have_link issue.title
    end
  end
end
