# frozen_string_literal: true

FactoryBot.define do
  factory :eligibility_verification do
    passenger
  end

  trait :with_agency do
    association :verifying_agency
  end

  trait :unexpired do
    with_agency
    expiration_date { 1.month.from_now }
  end

  trait :expired_within_grace_period do
    with_agency
    expiration_date { 2.business_days.ago }
  end

  trait :expiring_soon do
    with_agency
    expiration_date { 6.days.from_now }
  end

  trait :expired do
    with_agency
    expiration_date { EligibilityVerification.grace_period - 3.days }
  end
end
