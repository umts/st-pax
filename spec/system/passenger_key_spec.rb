# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passenger Keys' do
  before :each do
    when_current_user_is :admin
  end
  context 'doctors note will expire in a week' do
    it 'gives the correct class to the row' do
      create :temporary_passenger, :expiring_soon
      visit passengers_path
      expect(page).to have_css('tr.expires-soon')
    end
  end
  context 'doctors note is recently expired' do
    it 'gives the correct class to the row' do
      create :temporary_passenger, :expired_within_grace_period
      visit passengers_path
      expect(page).to have_css('tr.needs-note')
    end
  end
  context 'No Note' do
    it 'gives the correct class to the row' do
      create :temporary_passenger, :no_note
      visit passengers_path
      expect(page).to have_css('tr.needs-note')
    end
  end
end
