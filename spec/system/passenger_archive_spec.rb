# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Archived Passenger Management' do
  before :each do
    @user = create :user, :admin
    when_current_user_is(@user)
    @passenger = create :passenger,
      name: 'Zim',
      active_status: 'archived'
  end
  context 're-activating a temporary passenger' do
    context 'having filled in the correct data' do
      before :each do
        create :eligibility_verification,
          :with_agency,
          passenger: @passenger
      end
      it 'successfully reactivates the passenger' do
        visit archived_passengers_path
        expect(page).to have_text 'Zim'
        click_button 'Reactivate'
        expect(@passenger.reload).to be_active
      end
    end
    context 'having not filled in the correct data' do
      it 'puts an error in the flash' do
        visit archived_passengers_path
        expect(page).to have_text 'Zim'
        click_button 'Reactivate'
        expect(page).to have_text 'Eligibility verification required for temporary passengers with active registration'
      end
    end
  end
end
