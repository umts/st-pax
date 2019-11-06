# frozen_string_literal: true

FactoryBot.define do
  factory :passenger do
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    sequence(:spire) { |n| n.to_s.rjust(8, '0') + '@umass.edu' }
    active_status { 'active' }

    trait :temporary do
      permanent { false }
    end

    trait :permanent do
      permanent { true }
      verification { nil }
    end

    trait :inactive do
      after :create do |passenger|
        create :verification, :expired, passenger: passenger
      end
    end

    trait :unverified do
      verification { nil }
    end

    trait :with_verification do
      after :create do |passenger|
        create :verification, passenger: passenger
      end
    end

    trait :expired_within_grace_period do
      after :create do |passenger|
        create :verification, :expired_within_grace_period, passenger: passenger
      end
    end

    trait :expiring_soon do
      after :create do |passenger|
        create :verification, :expiring_soon, passenger: passenger
      end
    end
  end
end
