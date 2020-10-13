# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Carrier Management', js: true do
  let(:submit) { click_button 'Save' }
  context 'as admin' do
    before :each do
      @user = create :user, :admin
      when_current_user_is(@user)
    end

    context 'creating a new carrier' do
      before :each do
        visit carriers_path
        click_on 'New Carrier'
      end
      it 'successfully creates the carrier' do
        fill_in 'Name', with: 'Verizon'
        fill_in 'Gateway address', with: '@vzw.com'
        submit
        expect(page).to have_text 'Carrier successfully created'
        within 'tbody' do
          expect(page).to have_text 'Verizon'
          expect(page).to have_text '@vzw.com'
        end
      end
      context 'fails to create the carrier' do
        it 'verifies the presence of a name and gateway address' do
          submit
          expect(page).to have_text "Name can't be blank"
          expect(page).to have_text "Gateway address can't be blank"
        end
        it 'verifies the uniqueness of name and gateway address' do
          create :carrier, name: 'ATT', gateway_address: '@ATT.com'
          fill_in 'Name', with: 'att'
          fill_in 'Gateway address', with: '@att.com'
          submit
          expect(page).to have_text 'Name has already been taken'
          expect(page).to have_text 'Gateway address has already been taken'
        end
      end
      it 'goes back' do
        click_on 'Back'
        within 'tbody' do
          expect(page).not_to have_text 'tmobile'
          expect(page).not_to have_text '@tmo.com'
        end
      end
    end

    context 'editing a carrier' do
      before :each do
        create :carrier, name: 'tmobile', gateway_address: '@tmo.com'
        visit carriers_path
        click_on 'Edit'
      end
      it 'successfully updates the carrier' do
        fill_in 'Name', with: 'Verizon'
        fill_in 'Gateway address', with: '@vzw.com'
        submit
        expect(page).to have_text 'Carrier successfully updated'
        within 'tbody' do
          expect(page).to have_text 'Verizon'
          expect(page).not_to have_text 'tmobile'
          expect(page).to have_text '@vzw.com'
          expect(page).not_to have_text '@tmo.com'
        end
      end
      it 'fails to update the carrier' do
        fill_in 'Name', with: ''
        submit
        expect(page).to have_text "Name can't be blank"
      end
    end

    context 'deleting a carrier' do
      before :each do
        @carrier = create :carrier, name: 'tmobile', gateway_address: '@tmo.com'
        visit carriers_path
      end
      it 'successfully deletes the carrier' do
        page.accept_confirm 'Are you sure?' do
          click_button 'Destroy'
        end
        expect(page).to have_text 'Carrier successfully destroyed'
        within 'tbody' do
          expect(page).to have_text 'No carriers to show.'
        end
      end
      it 'fails to delete the carrier' do
        allow_any_instance_of(Carrier).to receive(:destroy).and_return(false)
        page.accept_confirm 'Are you sure?' do
          click_button 'Destroy'
        end
        within 'tbody' do
          expect(page).to have_text 'tmobile'
          expect(page).to have_text '@tmo.com'
        end
      end
    end
  end
end
