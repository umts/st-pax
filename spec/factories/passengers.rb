# frozen_string_literal: true

FactoryGirl.define do
  factory :passenger do
    name { FFaker::Name.name }
    address { FFaker::Address.street_address }
    email { FFaker::Internet.email }
    phone { FFaker::PhoneNumber.short_phone_number }
    active true

    trait :temporary do
      permanent false
      doctors_note
    end

    trait :permanent do
      permanent true
      doctors_note nil
    end

    trait :recently_expired do
      after :create do |passenger|
        create :doctors_note, :recently_expired, passenger: passenger
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

    trait :inactive do
      active false
    end

    trait :no_note do
      doctors_note nil
    end
  end
end
