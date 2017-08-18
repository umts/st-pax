# frozen_string_literal: true

require 'rails_helper'

describe DoctorsNotesHelper do
  before :each do
    @doctors_note = create :doctors_note
  end
  describe 'expiration_check' do
    context 'will expire within warning period' do
      it "returns 'will_expire_soon'" do
        @doctors_note.update expiration_date: 5.days.since
        expect(helper.expiration_check(@doctors_note)).to eql 'will_expire_soon'
      end
    end
    context 'expired withing graced period' do
      it "returns 'expired_within_grace_period'" do
        @doctors_note.update expiration_date: 1.day.ago
        expect(helper.expiration_check(@doctors_note))
          .to eql 'expired_within_grace_period'
      end
    end
    context 'expired' do
      it "returns 'inactive'" do
        @doctors_note.update expiration_date: 10.days.ago
        expect(helper.expiration_check(@doctors_note)).to eql 'inactive'
      end
    end
    context 'expiration date blank' do
      it "returns 'no_note'" do
        expect(helper.expiration_check(@doctors_note)).to eql 'no_note'
      end
    end
  end
end
