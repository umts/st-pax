# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Archived Passenger Management' do
  let(:user) { create(:user, :admin) }
  let!(:passenger) { create(:passenger, name: 'Zim', registration_status: 'archived') }

  before do
    when_current_user_is(user)
    visit archived_passengers_path
  end

  context 'when re-activating a temporary passenger' do
    context 'with the correct data filled in' do
      before { create(:eligibility_verification, :with_agency, passenger:) }

      it 'successfully reactivates the passenger' do
        click_on 'Reactivate'
        expect(passenger.reload).to be_active
      end
    end

    context 'without the correct data filled in' do
      it 'puts an error in the flash' do
        click_on 'Reactivate'
        message = 'Eligibility verification is required for temporary passengers with active registration'
        expect(page).to have_text message
      end
    end
  end
end
