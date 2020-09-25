# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Passenger do
  context 'testing mailers upon creation' do
    it 'correct email is sent upon creation of active passenger' do
      mail = ActionMailer::MessageDelivery.new(PassengerMailer, :notify_active)
      expect(PassengerMailer).to receive(:notify_active).and_return mail
      expect(PassengerMailer).not_to receive(:notify_pending)
      expect(PassengerMailer).not_to receive(:notify_archived)
      expect(mail).to receive(:deliver_now).and_return true
      create :passenger, :permanent, active_status: 'active'
    end

    it 'correct email is sent upon creation of pending passenger' do
      mail = ActionMailer::MessageDelivery.new(PassengerMailer, :notify_pending)
      expect(PassengerMailer).to receive(:notify_pending).and_return mail
      expect(PassengerMailer).not_to receive(:notify_active)
      expect(PassengerMailer).not_to receive(:notify_archived)
      expect(mail).to receive(:deliver_now).and_return true
      create :passenger, active_status: 'pending'
    end
  end

  context 'testing methods' do
    before :each do
      @passenger = create :temporary_passenger, :with_note
    end

    describe 'set_status' do
      context 'setting the status to archived' do
        it 'sets the status and sends an email to the passenger' do
          mail = ActionMailer::MessageDelivery.new(PassengerMailer,
                                                   :notify_archived)
          expect(PassengerMailer).to receive(:notify_archived)
            .and_return mail
          expect(mail).to receive(:deliver_now).and_return true
          @passenger.set_status('archived')
        end
      end
      context 'setting the status to active or pending' do
        it 'sets the status to pending' do
          @passenger.active!
          expect{ @passenger.set_status('pending') }
            .to change { @passenger.active_status }
        end
        it 'sets the status to pending' do
          @passenger.pending!
          expect{ @passenger.set_status('active') }
            .to change { @passenger.active_status }
        end
      end
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
          date = @passenger.eligibility_verification.expiration_date
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
            @passenger.eligibility_verification.update(expiration_date: date)
            expect(@passenger.rides_expire).to eq 3.business_days.since(date)
          end
        end
        context 'the doctors note is not expired' do
          it 'returns three business days after the expiration date of the note' do
            date = 14.days.from_now.to_date
            @passenger.eligibility_verification.update(expiration_date: date)
            expect(@passenger.rides_expire).to eq 3.business_days.after(date)
          end
        end
      end
      context 'temporary passenger has no doctors note' do
        it 'returns 3 business days after the registration date' do
          passenger = create :passenger
          date = passenger.registration_date
          expect(passenger.rides_expire).to eq 3.business_days.after(date)
        end
      end
      context 'passenger is a new record' do
        it 'returns 3 days from now' do
          expect(Passenger.new.rides_expire).to eq 3.business_days.from_now.to_date
        end
      end
    end
  end
end
