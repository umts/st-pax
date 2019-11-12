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
      registration_date { 1.month.ago }
      association :verification, :expired
    end

    trait :unverified do
      verification { nil }
    end

    trait :verified do
      verification
    end

    trait :expired_within_grace_period do
      registration_date { 3.days.ago }
      association :verification, :expired_within_grace_period
    end

    trait :expiring_soon do
      registration_date { 1.month.ago }
      association :verification, :expiring_soon
    end
  end
end
