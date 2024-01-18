# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passenger Show' do
  context 'as a dispatcher' do
    before do
      @passenger = create(:passenger, name: 'Foo Bar')
      user = create(:user)
      when_current_user_is(user)
      visit passengers_path
    end

    context 'viewing passenger' do
      let(:number) { @passenger.phone.delete('-') }

      context 'passenger is subscribed to sms' do
        it 'displays the subscription status' do
          @passenger.update(subscribed_to_sms: true)
          click_on 'View'
          expect(page).to have_text 'Subscribed to SMS: Yes'
        end
      end

      context 'passenger is not subscribed to sms' do
        it 'displays the subscription status' do
          click_on 'View'
          expect(page).to have_text 'Subscribed to SMS: No'
        end
      end
    end
  end
end
