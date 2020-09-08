# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pending Passenger Management' do
  before :each do
    @user = create :user, :admin
    when_current_user_is(@user)
    @passenger = create :passenger,
      name: 'Zim',
      active_status: 'pending'
  end
  context 'confirming a registration' do
    context 'having filled in the correct data' do
      before :each do
        create :eligibility_verification,
          :with_agency,
          passenger: @passenger
      end
      it 'successfully activates the passenger' do
        visit pending_passengers_path
        expect(page).to have_text 'Zim'
        click_button 'Confirm Registration'
        expect(@passenger.reload).to be_active
      end
    end
    context 'having not filled in the correct data' do
      it 'puts an error in the flash' do
        visit pending_passengers_path
        expect(page).to have_text 'Zim'
        click_button 'Confirm Registration'
        message = 'Eligibility verification is required for temporary passengers with active registration'
        expect(page).to have_text message
      end
    end
  end
end
