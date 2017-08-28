# frozen_string_literal: true

FactoryGirl.define do
  factory :passenger do
    name { FFaker::Name.name }
    address { FFaker::Address.street_address }
    email { FFaker::Internet.email }
    phone { FFaker::PhoneNumber.short_phone_number }
    mobility_device { MobilityDevice.all.sample }
    active true

    trait :temporary do
      permanent false
    end

    trait :permanent do
      permanent true
      doctors_note nil
    end

    trait :inactive do
      active false
    end

    trait :no_note do
      doctors_note nil
    end

    trait :with_note do
      after :create do |passenger|
        create :doctors_note, passenger: passenger
      end
    end

    trait :expired_within_grace_period do
      after :create do |passenger|
        create :doctors_note, :expired_within_grace_period, passenger: passenger
      end
    end

    trait :expiring_soon do
      after :create do |passenger|
        create :doctors_note, :expiring_soon, passenger: passenger
      end
    end

    trait :expiration_overriden do
      after :create do |passenger|
        create :doctors_note, :overriden, passenger: passenger
      end
    end
  end
end
