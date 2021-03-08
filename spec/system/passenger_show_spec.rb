# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passenger Show' do
  context 'as a dispatcher' do
    before :each do
      @carrier = create :carrier, name: 'Verizon', gateway_address: '@vtext.com'
      @passenger = create :passenger, name: 'Foo Bar'
      user = create :user
      when_current_user_is(user)
      visit passengers_path
    end
    context 'viewing passenger' do
      let(:number) { @passenger.phone.delete('-') }
      context 'passenger is subscribed to sms' do
        it 'displays a SMS address ' do
          @passenger.update(subscribed_to_sms: true, carrier: @carrier)
          click_on 'View'
          expect(page).to have_text 'Subscribed to SMS: Yes'
          expect(page).to have_text "SMS address: #{number}#{@carrier.gateway_address}"
        end
      end
      context 'passenger is not subscribed to sms' do
        it 'does not display a SMS address' do
          click_on 'View'
          expect(page).to have_text 'Subscribed to SMS: No'
          expect(page).not_to have_text "SMS address: #{number}#{@carrier.gateway_address}"
        end
      end
    end
  end
end
