# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedbackHelper do
  describe 'github_url' do
    it "is a link to the configured repo's issues" do
      allow(Feedback).to receive(:repo).and_return('acme/widgets')
      expect(helper.github_url).to eq 'https://github.com/acme/widgets/issues'
    end
  end
end
