# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passenger Show' do
  let!(:passenger) { create(:passenger, name: 'Foo Bar') }

  context 'when the user is a dispatcher' do
    before do
      when_current_user_is :anyone
      visit passengers_path
    end

    context 'when the passenger is subscribed to sms' do
      before { passenger.update(subscribed_to_sms: true) }

      it 'displays the subscription status' do
        click_on 'View'
        expect(page).to have_text 'Subscribed to SMS: Yes'
      end
    end

    context 'when the passenger is not subscribed to sms' do
      it 'displays the subscription status' do
        click_on 'View'
        expect(page).to have_text 'Subscribed to SMS: No'
      end
    end
  end
end
