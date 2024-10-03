# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passenger self-registration' do
  context 'when registering for the first time', :js do
    let(:passenger) { build(:passenger) }
    let(:submit) { click_on 'Submit' }

    before do
      login_as passenger
      visit register_passengers_path
    end

    context 'without errors' do
      before do
        fill_in 'Address', with: '123 turkey lane'
        fill_in 'Phone', with: '123'
      end

      it 'creates a passenger' do
        submit
        when_current_user_is :anybody
        visit passengers_path
        expect(page).to have_text passenger.name
      end

      it 'creates a pending passenger' do
        submit
        when_current_user_is :anybody
        visit pending_passengers_path
        expect(page).to have_text passenger.name
      end

      it 'informs you of success' do
        submit
        expect(page).to have_text 'Passenger registration successful'
      end
    end

    context 'with errors' do
      before do
        fill_in 'Address', with: '123 turkey lane'
      end

      it 'does not create a new passenger' do
        submit
        when_current_user_is :anybody
        visit passengers_path
        expect(page).to have_no_text passenger.name
      end

      it 'renders errors in the flash' do
        submit
        expect(page).to have_text "Phone Number can't be blank"
      end
    end
  end

  context 'when editing a registration' do
    before do
      login_as passenger
      visit edit_passenger_path(passenger)
    end

    context 'when still pending' do
      let(:passenger) { create(:passenger, registration_status: 'pending') }

      it 'allows editing' do
        expect(page).to have_field 'Address'
      end

      it 'redirects to the edit page' do
        visit register_passengers_path
        expect(page).to have_current_path edit_passenger_path(passenger)
      end
    end

    context 'when now active' do
      let(:passenger) { create(:temporary_passenger, :with_note) }

      it 'redirects to the show page' do
        expect(page).to have_current_path passenger_path(passenger)
      end

      it 'redirects to the show page rather than allowing editing' do
        visit register_passengers_path
        expect(page).to have_current_path passenger_path(passenger)
      end

      it 'does not allow editing' do
        expect(page).to have_no_field 'Address'
      end

      it 'tells you to call instead' do
        expect(page).to have_text 'To edit your profile, please call'
      end
    end
  end
end
