# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passenger Management', js: true do
  context 'as an admin' do
    before :each do
      @user = create :user, :admin
      @passenger = create :passenger, name: 'Foo Bar'
      when_current_user_is(@user)
    end
    context 'creating a new passenger successfully' do
      it 'creates the passenger' do
        date = 2.days.since.strftime '%Y-%m-%d'
        visit passengers_path
        # links in the navbar cannot receive clickable events since they
        # wrap button elements. you must use click_button instead.
        click_button 'Add New Passenger'
        fill_in 'Passenger Name', with: 'Foo Bar'
        fill_in 'Email', with: 'foobar@invalid.com'
        fill_in 'Passenger Spire', with: '12345678@umass.edu'
        fill_in "Doctor's note expires", with: date
        click_button 'Submit'
        expect(page).to have_text 'Passenger successfully created.'
      end
      it 'checks for existing passengers if a duplicate spire is found' do
        visit passengers_path
        click_button 'Add New Passenger'
        fill_in 'Passenger Spire', with: "#{@passenger.spire}\t"
        expect(page).to have_text 'A passenger already exists for this Spire ID'
        expect(page).to have_button 'Add new passenger'
        expect(page).to have_link 'Edit existing passenger'
      end
    end
    context 'creating a new passenger unsuccessfully' do
      it 'renders an error in the flash' do
        visit passengers_path
        click_button 'Add New Passenger'
        fill_in 'Passenger Spire', with: 'invalid spire'
        click_button 'Submit'
        expect(page).to have_text 'Spire must be 8 digits followed by @umass.edu'
      end
    end
    context 'editing an existing passenger successfully' do
      it 'updates the passenger' do
        create :doctors_note, passenger: @passenger
        visit passengers_path
        click_link 'Edit'
        fill_in 'Passenger Name', with: 'Bar Foo'
        click_button 'Submit'
        expect(page).to have_text 'Passenger successfully updated.'
      end
    end
    context 'editing an existing passenger unsuccessfully' do
      it 'puts the error in the flash' do
        visit passengers_path
        click_link 'Edit'
        fill_in 'Passenger Spire', with: 'not a valid spire'
        click_button 'Submit'
        expect(page).to have_text 'Spire must be 8 digits followed by @umass.edu'
      end
    end
    context 'deleting an existing passenger successfully' do
      it 'deletes the passenger' do
        visit passengers_path
        page.accept_confirm 'Are you sure?' do
          click_button 'Delete'
        end
        expect(page).to have_text 'Passenger successfully destroyed.'
      end
    end
    context 'archiving a passenger successfully' do
      it 'archives the passenger' do
        visit passengers_path
        click_button 'Archive'
        expect(page).to have_text 'Passenger successfully updated'
        expect(@passenger.reload).to be_archived
      end
    end
    context 'creating a temporary passenger without a doctors note' do
      it 'creates the passenger' do
        visit new_passenger_path
        fill_in 'Passenger Name', with: 'Jane Fonda'
        fill_in 'Passenger Spire', with: '12345678@umass.edu'
        fill_in 'Email', with: 'jfonda@umass.edu'
        select 'Student', from: 'UMass Status'
        click_button 'Submit'
        expect(page).to have_text 'Passenger successfully created.'
      end
    end
  end
  context 'as a dispatcher' do
    before :each do
      @user = create :user
      @passenger = create :passenger, name: 'Foo Bar'
      when_current_user_is(@user)
    end
    context 'creating a new passenger successfully' do
      it 'creates the passenger' do
        date = 2.days.since.strftime '%Y-%m-%d'
        visit passengers_path
        click_button 'Add New Passenger'
        fill_in 'Passenger Name', with: 'Foo Bar'
        fill_in 'Email', with: 'foobar@invalid.com'
        fill_in "Doctor's note expires", with: date
        fill_in 'Passenger Spire', with: '12345678@umass.edu'
        click_button 'Submit'
        expect(page).to have_text 'Passenger successfully created.'
      end
    end
    context 'editing an existing passenger successfully' do
      it 'updates the passenger' do
        create :doctors_note, passenger: @passenger
        visit passengers_path
        click_link 'Edit'
        fill_in 'Passenger Name', with: 'Bar Foo'
        click_button 'Submit'
        expect(page).to have_text 'Passenger successfully updated.'
      end
    end
    context 'wanting to delete a passenger' do
      it 'does not have a button to do so' do
        visit passengers_path
        expect(page).not_to have_button 'Delete'
      end
    end
  end
end
