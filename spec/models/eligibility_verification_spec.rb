# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EligibilityVerification do
  let(:verification) { create(:eligibility_verification) }

  describe '#will_expire_within_warning_period?' do
    subject(:call) { verification.will_expire_within_warning_period? }

    context 'when the expiration date is 5 days ago' do
      before { verification.update expiration_date: 5.days.ago }

      it { is_expected.to be(false) }
    end

    context 'when the expiration date is 5 days from now' do
      before { verification.update expiration_date: 5.days.from_now }

      it { is_expected.to be(true) }
    end
  end

  describe '#expired_within_grace_period?' do
    subject(:call) { verification.expired_within_grace_period? }

    context 'when the expiration date is in the future' do
      before { verification.update expiration_date: 1.day.from_now }

      it { is_expected.to be(false) }
    end

    context 'when the expiration date is less than 3 business days in the past' do
      before { verification.update expiration_date: 1.business_day.ago }

      it { is_expected.to be(true) }
    end
  end

  describe '#expired?' do
    subject(:call) { verification.expired? }

    context 'when the expiration date is 10 days ago' do
      before { verification.update expiration_date: 10.days.ago }

      it { is_expected.to be(true) }
    end

    context 'when the expiration date is 2 days from now' do
      before { verification.update expiration_date: 2.days.from_now }

      it { is_expected.to be(false) }
    end
  end
end
