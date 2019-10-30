# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Feedback do
  describe '#submit!' do
    it 'creates an issue'
    it 'sets the issue attribute'
  end

  describe '#load' do
    it 'loads the issue from GitHub'
    it 'sets the title from the issue'
    it 'sets the description from the issue'
    it 'sets the category based on the issue labels'
  end

  describe '#client' do
    it 'is an Octokit::Client if there is a token'
    it 'is a mock client if there is no token'
  end
end
