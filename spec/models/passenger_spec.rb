# frozen_string_literal: true

require 'rails_helper'

describe Passenger do
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
      it 'returns the expiration date' do
        date = 14.days.since
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
    context 'permaent passenger' do
      it 'returns nil' do
        @passenger.update permanent: true
        expect(@passenger.rides_expire).to be nil
      end
    end
    context 'doctors note present' do
      it 'returns the expiration date of the note' do
        date = 14.days.since.to_date
        create :doctors_note, passenger: @passenger, expiration_date: date
        expect(@passenger.rides_expire).to eq date
      end
    end
    context 'temporary, no docs note, but not new' do
      it 'returns 3 days after the registration date' do
        date = @passenger.registration_date + 3.days
        expect(@passenger.rides_expire).to eq date
      end
    end
    context 'passenger is a new record' do
      it 'returns 3 days from now' do
        expect(Passenger.new.rides_expire).to eq 3.days.since.to_date
      end
    end
  end
end
