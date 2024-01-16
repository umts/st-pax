# frozen_string_literal: true

FactoryBot.define do
  factory :passenger do
    name { FFaker::Name.name }
    address { FFaker::Address.street_address }
    email { FFaker::Internet.email }
    phone { FFaker::PhoneNumber.short_phone_number }
    sequence(:spire) { |n| format('%08i@umass.edu', n) }

    factory :temporary_passenger do
      permanent { false }

      trait :with_note do
        after(:create) do |passenger|
          create(:eligibility_verification, :unexpired, passenger:)
          passenger.active!
        end
      end

      trait :inactive do
        after(:create) do |passenger|
          create(:eligibility_verification, :expired, passenger:)
        end
      end

      trait :no_note do
        eligibility_verification { nil }
      end

      trait :expired_within_grace_period do
        after(:create) do |passenger|
          create(:eligibility_verification, :expired_within_grace_period, :with_agency, passenger:)
          passenger.active!
        end
      end

      trait :expiring_soon do
        after :create do |passenger|
          create(:eligibility_verification, :expiring_soon, :with_agency, passenger:)
          passenger.active!
        end
      end
    end

    trait :with_mobility_device do
      mobility_device { MobilityDevice.all.sample }
    end

    trait :permanent do
      permanent { true }
    end
  end
end
