# frozen_string_literal: true

FactoryBot.define do
  factory :passenger do
    name { FFaker::Name.name }
    address { FFaker::Address.street_address }
    email { FFaker::Internet.email }
    phone { FFaker::PhoneNumber.short_phone_number }
    sequence(:spire) { |n| n.to_s.rjust(8, '0') + '@umass.edu' }
    active_status { 'active' }
    registration_date { Time.zone.today }

    trait :with_mobility_device do
      mobility_device { MobilityDevice.all.sample }
    end

    trait :temporary do
      permanent { false }
    end

    trait :permanent do
      permanent { true }
      eligibility_verification { nil }
    end

    trait :inactive do
      association :eligibility_verification, :expired
    end

    trait :no_note do
      eligibility_verification { nil }
    end

    trait :with_note do
      association :eligibility_verification
    end

    trait :expired_within_grace_period do
      association :eligibility_verification, :expired_within_grace_period
    end

    trait :expiring_soon do
      association :eligibility_verification, :expiring_soon
    end
  end
end
