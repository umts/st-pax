# frozen_string_literal: true

require 'rails_helper'

feature 'Archived Passenger Management' do
  before :each do
    @user = create :user, :admin
    when_current_user_is(@user)
    @passenger = create :passenger, name: 'Zim', active_status: 'archived'
  end
  scenario 're-activating a passenger' do
    visit archived_passengers_path
    expect(page).to have_text 'Zim'
    click_button 'Reactivate'
    expect(@passenger.reload).to be_active
  end
end
