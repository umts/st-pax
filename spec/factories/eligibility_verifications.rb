# frozen_string_literal: true

FactoryBot.define do
  factory :eligibility_verification do
    passenger
    expiration_date { 1.month.from_now }
  end

  trait :expired_within_grace_period do
    expiration_date { 2.business_days.ago }
  end

  trait :expiring_soon do
    expiration_date { 6.days.from_now }
  end

  trait :expired do
    expiration_date { EligibilityVerification.grace_period - 3.days }
  end
end
