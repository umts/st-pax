# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pending Passenger Management' do
  let!(:passenger) { create(:passenger, name: 'Zim', registration_status: 'pending') }

  before do
    when_current_user_is :admin
    visit pending_passengers_path
  end

  context 'with the correct data filled in' do
    before { create(:eligibility_verification, :with_agency, passenger:) }

    it 'successfully activates the passenger' do
      click_on 'Confirm Registration'
      expect(passenger.reload).to be_active
    end
  end

  context 'without the correct data filled in' do
    it 'puts an error in the flash' do
      click_on 'Confirm Registration'
      message = 'Eligibility verification is required for temporary passengers with active registration'
      expect(page).to have_text(message)
    end
  end
end
