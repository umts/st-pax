# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passenger Management', :js do
  let!(:passenger) { create(:passenger, name: 'Foo Bar') }
  let!(:verifying_agency) { create(:verifying_agency) }

  context 'when the user is an admin' do
    before { when_current_user_is :admin }

    context 'when creating a new passenger' do
      before do
        visit passengers_path
        click_on 'Add New Passenger'
      end

      context 'when passenger creation is successful' do
        let :fill do
          fill_in 'Name', with: 'Foo Baz'
          fill_in 'Email', with: 'foobar@invalid.com'
          fill_in 'Address', with: '123 turkey lane'
          fill_in 'Phone', with: '123'
          fill_in 'Spire', with: '12345678@umass.edu'
          fill_in 'How long will the passenger be with us?', with: 2.days.from_now.strftime('%F')
          select verifying_agency.name, from: 'Which agency verifies that this passenger needs rides?'
        end

        it 'creates the passenger' do
          fill
          click_on 'Submit'
          visit passengers_path
          expect(page).to have_text('Foo Baz')
        end

        it 'informs the user of success' do
          fill
          click_on 'Submit'
          expect(page).to have_text 'Passenger registration successful'
        end

        it 'creates a passenger subscribed to sms' do
          check 'Subscribed to sms'
          fill
          click_on 'Submit'
          expect(page).to have_text 'Passenger registration successful'
        end
      end

      context 'when trying to use a duplicate Spire ID' do
        before { fill_in('Spire', with: passenger.spire).send_keys(:tab) }

        it 'warns about the duplication' do
          expect(page).to have_text 'A passenger already exists for this Spire ID'
        end

        it 'allows continued editing to fix the error' do
          expect(page).to have_button 'Add new passenger'
        end

        it 'offers a link to edit the existing passenger' do
          expect(page).to have_link 'Edit existing passenger'
        end
      end

      context 'when passenger creation is unsuccessful' do
        before do
          fill_in 'Name', with: 'Foo Baz'
          fill_in 'Email', with: 'foobar@invalid.com'
          fill_in 'Spire', with: '12345678@umass.edu'
          fill_in 'How long will the passenger be with us?', with: 2.days.from_now.strftime('%F')
        end

        it 'does not create the passenger' do
          click_on 'Submit'
          visit passengers_path
          expect(page).to have_no_text('Foo Baz')
        end

        it 'renders spire errors in the flash' do
          fill_in 'Spire', with: 'invalid spire'
          click_on 'Submit'
          expect(page).to have_text 'Spire must be 8 digits followed by @umass.edu'
        end

        it 'renders verification errors in the flash' do
          click_on 'Submit'
          expect(page).to have_text 'Which agency verifies that this passenger needs rides?'
        end
      end
    end

    context 'when editing an existing passenger' do
      before do
        create(:eligibility_verification, passenger:)
        visit passengers_path
        click_on 'Edit'
        fill_in 'Name', with: 'Bar Foo'
      end

      it 'updates the passenger' do
        click_on 'Submit'
        visit passengers_path
        expect(page).to have_text('Bar Foo').and(have_no_text(passenger.name))
      end

      it 'informs the user of success' do
        click_on 'Submit'
        expect(page).to have_text 'Registration successfully updated'
      end

      it 'puts errors in the flash' do
        fill_in 'Spire', with: 'not a valid spire'
        click_on 'Submit'
        expect(page).to have_text 'Spire must be 8 digits followed by @umass.edu'
      end
    end

    context 'when deleting an existing passenger' do
      subject(:delete) do
        page.accept_confirm('Are you sure?') { click_on 'Delete' }
      end

      before do
        visit passengers_path
      end

      it 'deletes the passenger' do
        delete
        visit passengers_path
        expect(page).to have_no_text(passenger.name)
      end

      it 'informs the user of success' do
        delete
        expect(page).to have_text 'Passenger successfully destroyed'
      end
    end

    context 'when archiving a passenger' do
      it 'archives the passenger' do
        visit passengers_path
        click_on 'Archive'
        visit archived_passengers_path
        expect(page).to have_text(passenger.name)
      end

      it 'tells you the passenger has been archived' do
        visit passengers_path
        click_on 'Archive'
        expect(page).to have_text 'Passenger successfully updated'
      end
    end

    context "when creating a temporary passenger without a doctor's note" do
      before do
        visit new_passenger_path
        fill_in 'Name', with: 'Jane Fonda'
        fill_in 'Spire', with: '12345678@umass.edu'
        fill_in 'Email', with: 'jfonda@umass.edu'
        fill_in 'Address', with: '123 turkey lane'
        fill_in 'Phone', with: '123'
      end

      context 'with a pending registration status' do
        before { choose 'Pending' }

        it 'creates the passenger' do
          click_on 'Submit'
          visit passengers_path
          expect(page).to have_text('Jane Fonda')
        end

        it 'informs the user of success' do
          click_on 'Submit'
          expect(page).to have_text 'Passenger registration successful'
        end
      end

      context 'with an active registration status' do
        it 'does not create the passenger' do
          visit passengers_path
          expect(page).to have_no_text('Jane Fonda')
        end

        it 'displays an error message' do
          click_on 'Submit'
          expect(page).to have_text <<~MSG.squish
            Eligibility verification expiration date must be entered for
            temporary passengers with an active registration status
          MSG
        end
      end
    end
  end

  context 'when the user is a dispatcher' do
    before { when_current_user_is :anyone }

    context 'when creating a new passenger' do
      before do
        visit new_passenger_path
        fill_in 'Name', with: 'Jane Fonda'
        fill_in 'Spire', with: '12345678@umass.edu'
        fill_in 'Email', with: 'jfonda@umass.edu'
        fill_in 'Address', with: '123 turkey lane'
        fill_in 'Phone', with: '123'
      end

      context 'with a pending registration status' do
        before { choose 'Pending' }

        it 'creates the passenger' do
          click_on 'Submit'
          visit passengers_path
          expect(page).to have_text('Jane Fonda')
        end

        it 'informs the user of success' do
          click_on 'Submit'
          expect(page).to have_text 'Passenger registration successful'
        end
      end

      context 'with active registration status' do
        it 'does not create the passenger' do
          visit passengers_path
          expect(page).to have_no_text('Jane Fonda')
        end

        it 'displays an error message' do
          click_on 'Submit'
          expect(page).to have_text <<~MSG.squish
            Eligibility verification expiration date must be entered for
            temporary passengers with an active registration status
          MSG
        end
      end

      context 'when editing an existing passenger' do
        before do
          create(:eligibility_verification, passenger:)
          visit passengers_path
          click_on 'Edit'
          fill_in 'Name', with: 'Bar Foo'
        end

        it 'updates the passenger' do
          click_on 'Submit'
          visit passengers_path
          expect(page).to have_text('Bar Foo')
        end

        it 'informs the user of success' do
          click_on 'Submit'
          expect(page).to have_text 'Registration successfully updated'
        end
      end

      it 'does not offer a button to delete a passenger' do
        visit passengers_path
        expect(page).to have_no_button 'Delete'
      end
    end
  end
end
