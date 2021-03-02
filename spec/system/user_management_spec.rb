# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Management' do
  before :each do
    @user = create :user
    when_current_user_is :admin
  end
  context 'deleting a user unsuccessfully', js: true do
    before :each do
      @log = create :log_entry, user: @user
    end
    it 'puts the errors in the flash' do
      visit users_path
      # Click the 'destroy' link in the user's row
      page.accept_confirm 'Are you sure?' do
        within('tr', text: @user.name) { click_on 'Destroy' }
      end
      expect(page).to have_text(
        'Cannot delete record because dependent log entries exist'
      )
    end
  end
  context 'deleting a user successfully', js: true do
    it 'deletes the user and says it did' do
      visit users_path
      page.accept_confirm 'Are you sure?' do
        within('tr', text: @user.name) { click_on 'Destroy' }
      end
      expect(page).to have_text(
        'User successfully destroyed'
      )
    end
  end
  context 'editing an existing user successfully' do
    it 'updates the user' do
      visit users_path
      within('tr', text: @user.name) { click_on 'Edit' }
      fill_in 'Name', with: 'Bar Foo'
      click_button 'Save'
      expect(page).to have_text 'User successfully updated'
    end
  end
  context 'editing an existing user unsuccessfully' do
    it 'puts the error in the flash' do
      visit users_path
      within('tr', text: @user.name) { click_on 'Edit' }
      fill_in 'Spire', with: 'not a valid spire'
      click_button 'Save'
      expect(page).to have_text 'Spire must be 8 digits followed by @umass.edu'
    end
  end
  context 'creating a new user successfully' do
    it 'creates the user' do
      visit users_path
      click_link 'New User'
      fill_in 'Name', with: 'Foo Bar'
      fill_in 'Spire', with: '12345678@umass.edu'
      click_button 'Save'
      expect(page).to have_text 'User successfully created'
    end
  end
  context 'creating a new user unsuccessfully' do
    it 'renders an error in the flash' do
      visit users_path
      click_link 'New User'
      fill_in 'Spire', with: 'invalid spire'
      click_button 'Save'
      expect(page).to have_text 'Spire must be 8 digits followed by @umass.edu'
    end
  end
end
