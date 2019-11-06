# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passenger Keys' do
  before :each do
    when_current_user_is :admin
  end
  context 'verificatio will expire in a week' do
    it 'gives the correct class to the row' do
      create :passenger, :expiring_soon
      visit passengers_url
      expect(page).to have_css('tr.expires-soon')
    end
  end
  context 'verification is recently expired' do
    it 'gives the correct class to the row' do
      create :passenger, :expired_within_grace_period
      visit passengers_url
      expect(page).to have_css('tr.needs-note')
    end
  end
  context 'No Note' do
    it 'gives the correct class to the row' do
      create :passenger, :no_note
      visit passengers_url
      expect(page).to have_css('tr.needs-note')
    end
  end
end
