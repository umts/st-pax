# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PassengersHelper do
  describe 'passengers_table_row_class' do
    before :each do
      @passenger = create :passenger, :temporary, :with_verification
      @verification = @passenger.verification
    end
    context 'will expire within warning period' do
      it 'returns the correct class' do
        @verification.update expiration_date: 5.days.since
        expect(helper.passengers_table_row_class(@passenger))
          .to eql 'expires-soon'
      end
    end
    context 'expired within grace period' do
      it 'returns the correct class' do
        @verification.update expiration_date: 1.day.ago
        expect(helper.passengers_table_row_class(@passenger))
          .to eql 'needs-verification'
      end
    end
    context 'expired' do
      it 'returns the correct class' do
        @verification.update expiration_date: 10.days.ago
        @passenger.update registration_date: 10.days.ago
        expect(helper.passengers_table_row_class(@passenger)).to eql 'expired'
      end
    end
    context 'the passenger needs to be verified' do
      it 'returns the correct class' do
        @passenger = create :passenger, :temporary, :unverified
        expect(helper.passengers_table_row_class(@passenger)).to eql 'needs-verification'
      end
    end
  end
end
