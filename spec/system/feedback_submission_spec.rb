# frozen_string_literal: true

require 'rails_helper'
require 'mock_github_client'

RSpec.describe 'Feedback Submission' do
  let(:title) { 'The site is broken' }
  let(:client) { MockGithubClient.new(logger: Logger.new(nil)) }
  let(:issue) { client.issue('repo', -999) }

  before :each do
    allow(MockGithubClient).to receive(:new).and_return client

    @user = create :user
    when_current_user_is(@user)
    visit new_feedback_path
  end

  it 'renders the form again if feedback is invalid' do
    click_on 'Submit'
    expect(page).to have_text 'New Feedback'
    expect(page).to have_text "Title can't be blank"
  end

  it 'submits the feedback' do
    expect(client).to receive(:create_issue)
      .with(anything, title, '', hash_including(:labels)).and_call_original

    fill_in 'Title', with: title
    click_on 'Submit'
  end

  it 'redirects back if submission fails' do
    allow(client).to receive(:create_issue).and_raise(Octokit::Error)
    fill_in 'Title', with: title
    click_on 'Submit'

    expect(page).to have_text 'New Feedback'
    expect(page).to have_text 'external error occurred'
  end

  it 'displays the GitHub content if submission succeeds' do
    allow(client).to receive(:create_issue)
      .with(anything, title, '', hash_including(:labels)).and_call_original

    fill_in 'Title', with: title
    click_on 'Submit'

    expect(page).to have_current_path(feedback_path(1))
    expect(page).to have_link issue.title
  end
end
