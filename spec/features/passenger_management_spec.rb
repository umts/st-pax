# frozen_string_literal: true

require 'rails_helper'

feature 'Passenger Management' do
  feature 'as an admin' do
    before :each do
      @user = create :user, :admin
      @passenger = create :passenger, name: 'Foo Bar'
      when_current_user_is(@user)
    end
    scenario 'creating a new passenger' do
      date = 2.days.since.strftime '%Y-%m-%d'
      visit passengers_path
      click_link 'Add New Passenger'
      fill_in 'Passenger Name', with: 'Foo Bar'
      fill_in 'Email', with: 'foobar@invalid.com'
      fill_in 'Passenger Spire', with: '12345678@umass.edu'
      fill_in 'Expiration Date', with: date
      click_button 'Submit'
      expect(page).to have_text 'Passenger was successfully created.'
    end
    scenario 'editing an existing passenger' do
      create :doctors_note, passenger: @passenger
      visit passengers_path
      click_link 'Edit'
      fill_in 'Passenger Name', with: 'Bar Foo'
      click_button 'Submit'
      expect(page).to have_text 'Passenger was successfully updated.'
    end
    scenario 'deleting an existing passenger' do
      visit passengers_path
      click_link 'Delete'
      expect(page).to have_text 'Passenger was successfully destroyed.'
    end
    scenario 'creating a temporary passenger without a doctors note' do
      visit new_passenger_path
      fill_in 'Passenger Name', with: 'Jane Fonda'
      fill_in 'Passenger Spire', with: '12345678@umass.edu'
      fill_in 'Email', with: 'jfonda@umass.edu'
      select 'Student', from: 'UMass Status'
      click_button 'Submit'
      expect(page).to have_text 'Passenger was successfully created.'
    end
    scenario 'overriding expiration shows done by' do
      create :doctors_note, passenger: @passenger
      date = 2.days.since.strftime '%Y-%m-%d'
      visit passengers_path
      click_link 'Edit'
      check 'Override Expiration Date?'
      fill_in 'Override Until', with: date
      click_button 'Submit'
      expect(@passenger.reload.doctors_note.overridden_by).to eql(@user)
    end
  end
  feature 'as a dispatcher' do
    before :each do
      @user = create :user
      @passenger = create :passenger, name: 'Foo Bar'
      when_current_user_is(@user)
    end
    scenario 'creating a new passenger' do
      date = 2.days.since.strftime '%Y-%m-%d'
      visit passengers_path
      click_link 'Add New Passenger'
      fill_in 'Passenger Name', with: 'Foo Bar'
      fill_in 'Email', with: 'foobar@invalid.com'
      fill_in 'Expiration Date', with: date
      fill_in 'Passenger Spire', with: '12345678@umass.edu'
      click_button 'Submit'
      expect(page).to have_text 'Passenger was successfully created.'
    end
    scenario 'editing an existing passenger' do
      create :doctors_note, passenger: @passenger
      visit passengers_path
      click_link 'Edit'
      fill_in 'Passenger Name', with: 'Bar Foo'
      click_button 'Submit'
      expect(page).to have_text 'Passenger was successfully updated.'
    end
    scenario 'deleting an existing passenger' do
      visit passengers_path
      expect(page).not_to have_link 'Delete'
    end
    scenario 'overriding expiration date' do
      create :doctors_note, passenger: @passenger
      visit passengers_path
      expect(page).not_to have_checked_field 'Override Expiration Date?'
      expect(page).not_to have_field 'Override Until'
    end
  end
end
