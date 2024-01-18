# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Management' do
  let!(:user) { create(:user) }

  before do
    when_current_user_is :admin
    visit users_path
  end

  context 'when deleting a user', :js do
    subject :submit do
      page.accept_confirm 'Are you sure?' do
        within('tr', text: user.name) { click_on 'Destroy' }
      end
    end

    context 'when a user is not deletable' do
      before { create(:log_entry, user:) }

      it 'puts the errors in the flash' do
        submit
        expect(page).to have_text('Cannot delete record because dependent log entries exist')
      end
    end

    context 'when a user is deletable' do
      it 'deletes the user and says it did' do
        submit
        expect(page).to have_text('User successfully destroyed')
      end
    end
  end

  context 'when editing a user' do
    before do
      within('tr', text: user.name) { click_on 'Edit' }
    end

    it 'updates the user' do
      fill_in 'Name', with: 'Bar Foo'
      click_on 'Save'
      expect(page).to have_text('User successfully updated')
    end

    it 'puts the error in the flash' do
      fill_in 'Spire', with: 'not a valid spire'
      click_on 'Save'
      expect(page).to have_text('Spire must be 8 digits followed by @umass.edu')
    end
  end

  context 'when creating a new user' do
    before do
      click_on 'New User'
    end

    it 'creates the user' do
      fill_in 'Name', with: 'Foo Bar'
      fill_in 'Spire', with: '12345678@umass.edu'
      click_on 'Save'
      expect(page).to have_text 'User successfully created'
    end

    it 'renders an error in the flash' do
      fill_in 'Spire', with: 'invalid spire'
      click_on 'Save'
      expect(page).to have_text 'Spire must be 8 digits followed by @umass.edu'
    end
  end
end
