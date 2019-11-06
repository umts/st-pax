# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Verification do
  before :each do
    @verification = create :verification
  end

  describe 'will_expire_within_warning_period?' do
    context 'expiration date: 5 days ago' do
      it 'returns false' do
        @verification.update expiration_date: 5.days.ago
        expect(@verification.will_expire_within_warning_period?).to be false
      end
    end
    context 'expiration date: 5 days since' do
      it 'returns true' do
        @verification.update expiration_date: 5.days.since
        expect(@verification.will_expire_within_warning_period?).to be true
      end
    end
  end

  describe 'expired_within_grace_period?' do
    context 'the expiration date is in the future' do
      it 'returns false' do
        @verification.update expiration_date: 1.day.from_now
        expect(@verification.expired_within_grace_period?).to be false
      end
    end
    context 'the expiration date is less than 3 business days in the past' do
      it 'returns true' do
        @verification.update expiration_date: 1.business_day.ago
        expect(@verification.expired_within_grace_period?).to be true
      end
    end
  end

  describe 'expired?' do
    context 'expiration date: 10 days ago' do
      it 'returns true' do
        @verification.update expiration_date: 10.days.ago
        expect(@verification.expired?).to be true
      end
    end
    context 'expiration date: 2 days since' do
      it 'returns false' do
        @verification.update expiration_date: 2.days.since
        expect(@verification.expired?).to be false
      end
    end
  end
end
