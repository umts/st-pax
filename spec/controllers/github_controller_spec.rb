# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GithubController do
  describe 'GET callback' do
    subject(:submit) { get :callback, params: { code: } }

    let(:code) { 'OAUTH-CODE-FROM-GITHUB' }
    let(:token_instance) { IssueToken.instance }
    let(:new_token) { 'A NEW TOKEN' }

    before do
      allow(Octokit).to receive(:exchange_code_for_token).and_return({ access_token: new_token })
      allow(IssueToken).to receive(:instance).and_return token_instance
      allow(token_instance).to receive(:update)
      when_current_user_is :admin
    end

    it 'exchanges the code from GitHub for an access token' do
      submit

      expect(Octokit).to have_received(:exchange_code_for_token).with(code, anything, anything)
    end

    it 'updates the IssueToken' do
      submit

      expect(token_instance).to have_received(:update).with(token: new_token)
    end
  end
end
