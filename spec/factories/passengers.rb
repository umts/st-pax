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
      doctors_note { nil }
    end

    trait :inactive do
      association :doctors_note, :expired
    end

    trait :no_note do
      doctors_note { nil }
    end

    trait :with_note do
      association :doctors_note
    end

    trait :expired_within_grace_period do
      association :doctors_note, :expired_within_grace_period
    end

    trait :expiring_soon do
      association :doctors_note, :expiring_soon
    end
  end
end
