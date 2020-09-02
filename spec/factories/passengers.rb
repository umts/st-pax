# frozen_string_literal: true

FactoryBot.define do
  factory :passenger do
    name { FFaker::Name.name }
    address { FFaker::Address.street_address }
    email { FFaker::Internet.email }
    phone { FFaker::PhoneNumber.short_phone_number }
    sequence(:spire) { |n| n.to_s.rjust(8, '0') + '@umass.edu' }

    factory :temporary_passenger do
      permanent { false }

      trait :with_note do
        after(:create) do |passenger|
          create :eligibility_verification,
                 :with_agency,
                 passenger: passenger
          passenger.active!
        end
      end

      trait :inactive do
        after(:create) do |passenger|
          create :eligibility_verification, :expired, passenger: passenger
        end
      end

      trait :no_note do
        eligibility_verification { nil }
      end

      trait :expired_within_grace_period do
        after(:create) do |passenger|
          create :eligibility_verification,
                 :expired_within_grace_period, :with_agency,
                 passenger: passenger
          passenger.active!
        end
      end

      trait :expiring_soon do
        after :create do |passenger|
          create :eligibility_verification,
                 :expiring_soon, :with_agency,
                 passenger: passenger
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

    trait :subscribed_to_sms do
      subscribed_to_sms { true }
      carrier { Carrier.all.sample }
    end
  end
end
