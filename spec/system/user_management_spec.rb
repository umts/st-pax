# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Management', js: true do
  before :each do
    @user = create :user
    when_current_user_is(create :user, :admin)
  end
  context 'deleting a user unsuccessfully' do
    before :each do
      @log = create :log_entry, user: @user
    end
    it 'puts the errors in the flash' do
      visit users_url
      # Find destroy link by href because there are 2 users by necessity.
      # Although you definitely _can_ delete yourself.
      find(:xpath, "//a[@href='/users/#{@user.id}']").click
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_text(
        'Cannot delete record because dependent log entries exist'
      )
    end
  end
  context 'deleting a user successfully' do
    it 'deletes the user and says it did' do
      visit users_url
      find(:xpath, "//a[@href='/users/#{@user.id}']").click
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_text(
        'User successfully destroyed'
      )
    end
  end
  context 'editing an existing user successfully' do
    it 'updates the user' do
      visit users_path
      find(:xpath, "//a[@href='/users/#{@user.id}/edit']").click
      fill_in 'Name', with: 'Bar Foo'
      click_button 'Save'
      expect(page).to have_text 'User successfully updated'
    end
  end
  context 'editing an existing user unsuccessfully' do
    it 'puts the error in the flash' do
      visit users_path
      find(:xpath, "//a[@href='/users/#{@user.id}/edit']").click
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