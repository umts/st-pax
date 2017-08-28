# frozen_string_literal: true

FactoryGirl.define do
  factory :doctors_note do
    passenger
    override_expiration false
    expiration_date { rand(150).days.since }
  end

  trait :overriden do
    override_expiration true
    # TODO: I think this should be defined as a real association.
    overriden_by 1
    override_until { rand(30).days.since }
  end

  trait :expired_within_grace_period do
    expiration_date { DoctorsNote.grace_period - rand(3).days }
  end

  trait :expiring_soon do
    expiration_date { rand(7).days.since }
  end

  trait :expired do
    expiration_date { DoctorsNote.grace_period + rand(30).days }
  end
end
