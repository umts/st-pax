# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PassengerMailer do
  describe '.notify_active' do
    subject(:output) { described_class.notify_active(passenger) }

    let(:passenger) { create(:passenger) }
    let(:from_address) { described_class.default[:from] }

    it 'emails from correct value' do
      expect(output.from).to eq([from_address])
    end

    it 'emails correct passenger' do
      expect(output.to).to eq([passenger.email])
    end

    it 'has correct subject' do
      expect(output.subject).to eq("#{I18n.t 'department.name'} Account Confirmed")
    end
  end
end
