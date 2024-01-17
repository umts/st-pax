# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passenger Keys' do
  before { when_current_user_is :admin }

  context "with a doctor's note expiring in a week" do
    before do
      create(:temporary_passenger, :expiring_soon)
      visit passengers_path
    end

    it 'gives the correct class to the row' do
      expect(page).to have_css('tr.expires-soon')
    end
  end

  context "with a recently expired doctor's note" do
    before do
      create(:temporary_passenger, :expired_within_grace_period)
      visit passengers_path
    end

    it 'gives the correct class to the row' do
      expect(page).to have_css('tr.needs-note')
    end
  end

  context "without a doctor's note" do
    before do
      create(:temporary_passenger, :no_note)
      visit passengers_path
    end

    it 'gives the correct class to the row' do
      expect(page).to have_css('tr.needs-note')
    end
  end
end
