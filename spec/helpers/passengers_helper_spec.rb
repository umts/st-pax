# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PassengersHelper do
  describe 'passengers_table_row_class' do
    before :each do
      @passenger = create :passenger, :temporary, :with_note
      @doctors_note = @passenger.doctors_note
    end
    context 'will expire within warning period' do
      it "returns 'will_expire_soon'" do
        @doctors_note.update expiration_date: 5.days.since
        expect(helper.passengers_table_row_class(@passenger))
          .to eql 'will_expire_soon'
      end
    end
    context 'expired within grace period' do
      it "returns 'expired_within_grace_period'" do
        @doctors_note.update expiration_date: 1.day.ago
        expect(helper.passengers_table_row_class(@passenger))
          .to eql 'expired_within_grace_period'
      end
    end
    context 'expired' do
      it "returns 'inactive'" do
        @doctors_note.update expiration_date: 10.business_days.ago
        expect(helper.passengers_table_row_class(@passenger)).to eql 'inactive'
      end
    end
    context 'no note' do
      it "returns 'no_note'" do
        @passenger = create :passenger, :temporary, :no_note
        expect(helper.passengers_table_row_class(@passenger)).to eql 'no_note'
      end
    end
  end
end
