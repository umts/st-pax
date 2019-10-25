# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Passenger do
  before :each do
    @passenger = create :passenger, :temporary
  end

  describe 'expiration_display' do
    context 'permanent passenger' do
      it 'returns nil' do
        @passenger.update permanent: true
        expect(@passenger.expiration_display).to be nil
      end
    end
    context 'temporary passenger' do
      it 'returns the expiration date of the doctors note' do
        date = 14.days.from_now
        create :doctors_note, passenger: @passenger, expiration_date: date
        expect(@passenger.expiration_display).to eql date.strftime('%m/%d/%Y')
      end
    end
  end

  describe 'temporary?' do
    it 'returns true if the passenger is not permanent' do
      expect(@passenger.temporary?).to be true
    end
  end

  describe 'not having a SPIRE' do
    it 'is not valid' do
      passenger = build :passenger, spire: ''
      expect(passenger).not_to be_valid
    end
  end

  describe 'rides_expire' do
    context 'permanent passenger' do
      it 'returns nil' do
        @passenger.update permanent: true
        expect(@passenger.rides_expire).to be nil
      end
    end
    context 'doctors note present' do
      context 'doctors note is expired within grace period' do
        it 'returns 3 days from the doctors note expiry' do
          date = 2.days.ago.to_date
          create :doctors_note, passenger: @passenger, expiration_date: date
          expect(@passenger.rides_expire).to eq 3.business_days.since(date)
        end
      end
      context 'the doctors note is not expired' do
        it 'returns three business days after the expiration date of the note' do
          date = 14.days.from_now
          note = create :doctors_note, passenger: @passenger, expiration_date: date
          expect(@passenger.rides_expire).to eq 3.business_days.after(note.expiration_date)
        end
      end
    end
    context 'temporary passenger has no doctors note' do
      it 'returns 3 business days after the registration date' do
        date = @passenger.registration_date
        expect(@passenger.rides_expire).to eq 3.business_days.after(date)
      end
    end
    context 'passenger is a new record' do
      it 'returns 3 days from now' do
        expect(Passenger.new.rides_expire.to_date).to eq 3.business_days.from_now.to_date
      end
    end
  end
end
