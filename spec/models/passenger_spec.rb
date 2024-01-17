# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Passenger do
  let(:passenger) { create(:temporary_passenger, :with_note) }

  before do
    @passenger = create(:temporary_passenger, :with_note)
  end

  describe 'active passenger creation notifications' do
    let(:mail) { ActionMailer::MessageDelivery.new(PassengerMailer, :notify_active) }

    before do
      allow(PassengerMailer).to receive_messages(notify_active: mail, notify_pending: nil, notify_archived: nil)
      allow(mail).to receive(:deliver_now).and_return true
      create(:passenger, :permanent, registration_status: 'active')
    end

    it 'sends the correct email' do
      expect(PassengerMailer).to have_received(:notify_active)
    end

    it 'does now sent the incorrect email' do
      %i[notify_pending notify_archived].each do |mail_method|
        expect(PassengerMailer).not_to have_received(mail_method)
      end
    end

    it 'delivers the mail' do
      expect(mail).to have_received(:deliver_now)
    end
  end

  describe 'pending passenger creation notifications' do
    let(:mail) { ActionMailer::MessageDelivery.new(PassengerMailer, :notify_pending) }

    before do
      allow(PassengerMailer).to receive_messages(notify_active: nil, notify_pending: mail, notify_archived: nil)
      allow(mail).to receive(:deliver_now).and_return true
      create(:passenger, :permanent, registration_status: 'pending')
    end

    it 'sends the correct email' do
      expect(PassengerMailer).to have_received(:notify_pending)
    end

    it 'does now sent the incorrect email' do
      %i[notify_active notify_archived].each do |mail_method|
        expect(PassengerMailer).not_to have_received(mail_method)
      end
    end

    it 'delivers the mail' do
      expect(mail).to have_received(:deliver_now)
    end
  end

  describe '#set_status' do
    subject(:call) { ->(status) { passenger.set_status(status) } }

    context 'when setting the status to archived' do
      let(:mail) { ActionMailer::MessageDelivery.new(PassengerMailer, :notify_archived) }

      before do
        allow(PassengerMailer).to receive(:notify_archived).and_return mail
        allow(mail).to receive(:deliver_now).and_return true
      end

      it 'sets the status to archived' do
        expect { call['archived'] }.to change(passenger, :registration_status)
      end

      it 'sets the status and sends an email to the passenger' do
        call['archived']
        expect(mail).to have_received(:deliver_now)
      end
    end

    it 'sets the status to pending' do
      passenger.active!
      expect { call['pending'] }.to change(passenger, :registration_status)
    end

    it 'sets the status to active' do
      passenger.pending!
      expect { call['active'] }.to change(passenger, :registration_status)
    end
  end

  describe '#expiration_display' do
    subject(:call) { passenger.expiration_display }

    it 'returns nil for a permanent' do
      passenger.update permanent: true
      expect(call).to be_nil
    end

    it 'returns the expiration date of the doctors note for temporary passengers' do
      date = passenger.eligibility_verification.expiration_date
      expect(call).to eq(date.strftime('%m/%d/%Y'))
    end
  end

  describe '#temporary?' do
    subject(:call) { passenger.temporary? }

    it 'returns true if the passenger is not permanent' do
      expect(call).to be(true)
    end
  end

  describe 'not having a SPIRE' do
    it 'is not valid' do
      spireless_passenger = build(:passenger, spire: '')
      expect(spireless_passenger).not_to be_valid
    end
  end

  describe '#rides_expire' do
    subject(:call) { passenger.rides_expire }

    context 'with a permanent passenger' do
      it 'returns nil' do
        passenger.update permanent: true
        expect(call).to be_nil
      end
    end

    context "with a doctor's note that is expired within the grace period" do
      it 'returns 3 days from the doctors note expiry' do
        date = 2.days.ago.to_date
        passenger.eligibility_verification.update(expiration_date: date)
        expect(call).to eq(3.business_days.since(date))
      end
    end

    context "with a non-expired doctor's note" do
      it 'returns three business days after the expiration date of the note' do
        date = 14.days.from_now.to_date
        passenger.eligibility_verification.update(expiration_date: date)
        expect(call).to eq(3.business_days.after(date))
      end
    end

    context "with no doctor's note" do
      let(:passenger) { create(:passenger) }

      it 'returns 3 business days after the registration date' do
        date = passenger.registration_date
        expect(call).to eq(3.business_days.after(date))
      end
    end

    context 'when the passenger is a new record' do
      let(:passenger) { build(:passenger) }

      it 'returns 3 days from now' do
        expect(call).to eq(3.business_days.after(Time.zone.today))
      end
    end
  end
end
