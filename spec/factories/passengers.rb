# frozen_string_literal: true

FactoryGirl.define do
  factory :passenger do
    name { FFaker::Name.name }
    address { FFaker::Address.street_address }
    email { FFaker::Internet.email }
    phone { FFaker::PhoneNumber.short_phone_number }
    mobility_device
    permanent false
    active true

    trait :permanent do
      permanent true
      doctors_note nil
    end

    trait :recently_expired do
      doctors_note { create :doctors_note, expiration_date: rand(7).days.ago }
    end

    trait :expiring_soon do
      doctors_note { create :doctors_note, expiration_date: rand(7).days.since }
    end

    trait :expiration_overriden do
      doctors_note { create :doctors_note, :overriden }
    end

    trait :inactive do
      active false
    end

    trait :no_note do
      doctors_note nil
    end
  end
end
