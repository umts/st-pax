# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passenger self registration', js: true do
  context 'registering for the first time' do
    before :each do
      login_as(build :passenger)
    end
    let :submit do
      click_button 'Submit'
    end
    context 'successfully' do
      it 'creates a new pending passenger' do
        visit register_passengers_path
        fill_in 'Address', with: '123 turkey lane'
        fill_in 'Phone', with: '123'
        expect{ submit }.to change { Passenger.count }.by 1
        expect(page).to have_text 'Passenger registration successful'
        expect(Passenger.last).to be_pending
      end
    end
    context 'unsuccessfully' do
      it 'renders errors in the flash' do
        visit register_passengers_path
        fill_in 'Address', with: '123 turkey lane'
        expect{ submit }.not_to change { Passenger.count }
        expect(page).to have_text "Phone Number can't be blank"
      end
    end
  end
  context 'editing registration' do
    context 'while still pending' do
      it 'redirects to the edit page and allows editing' do
        @passenger = create :passenger, active_status: 'pending'
        login_as(@passenger)
        visit edit_passenger_path(@passenger)
        expect(page).to have_field 'Address'
        expect(page.current_url).to include edit_passenger_path(@passenger)
        visit register_passengers_path
        expect(page).to have_field 'Address'
        expect(page.current_url).to include edit_passenger_path(@passenger)
      end
    end
    context 'after becoming active' do
      it 'does not allow editing' do
        @passenger = create :temporary_passenger, :with_note
        login_as(@passenger)
        visit edit_passenger_path(@passenger)
        expect(page).not_to have_field 'Address'
        expect(page.current_url).to include passenger_path(@passenger)
        expect(page.current_url).not_to include edit_passenger_path(@passenger)
        expect(page).to have_text "To edit your profile, please call"
        visit register_passengers_path
        expect(page).not_to have_field 'Address'
        expect(page.current_url).to include passenger_path(@passenger)
        expect(page.current_url).not_to include edit_passenger_path(@passenger)
        expect(page).to have_text "To edit your profile, please call"
      end
    end
  end
end
