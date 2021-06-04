# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PassengersHelper do
  describe 'passengers_table_row_class' do
    subject(:call) { helper.passengers_table_row_class(passenger) }

    let(:passenger) { create :temporary_passenger, :with_note }
    let(:verification) { passenger.eligibility_verification }

    context 'when ev will expire within warning period' do
      before { verification.update expiration_date: 5.days.since }

      it { is_expected.to eq('expires-soon') }
    end

    context 'when ev is expired, but within grace period' do
      before { verification.update expiration_date: 1.day.ago }

      it { is_expected.to eq('needs-note') }
    end

    context 'when ev is expired' do
      before do
        verification.update expiration_date: 10.days.ago
        passenger.update registration_date: 10.days.ago
      end

      it { is_expected.to eq('expired') }
    end

    context 'when the passenger needs a doctors note' do
      let(:passenger) { create :temporary_passenger, :no_note }

      it { is_expected.to eq('needs-note') }
    end

    context 'when the passenger is archived' do
      let(:passenger) { create :passenger, registration_status: :archived }

      it { is_expected.to be(nil) }
    end
  end
end
