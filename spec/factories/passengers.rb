# frozen_string_literal: true

FactoryBot.define do
  factory :passenger do
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    sequence(:spire) { |n| n.to_s.rjust(8, '0') + '@umass.edu' }

    trait :active do
      active_status { 'active' }
    end

    trait :temporary do
      permanent { false }
    end

    trait :permanent do
      permanent { true }
    end

    trait :expired do
      association :eligibility_verification, :expired
      after :create do |passenger|
        passenger.update_attributes(registration_date: 1.month.ago)
      end
    end

    trait :unverified do
      eligibility_verification { nil }
    end

    trait :verified do
      eligibility_verification
    end

    trait :expired_within_grace_period do
      association :eligibility_verification, :expired_within_grace_period
    end

    trait :expiring_soon do
      association :eligibility_verification, :expiring_soon
    end
  end
end
