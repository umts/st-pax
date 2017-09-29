# frozen_string_literal: true

FactoryGirl.define do
  factory :doctors_note do
    passenger
    override_expiration false
    expiration_date { rand(150).days.since }
  end

  trait :overridden do
    override_expiration true
    overridden_by { create :user, :admin }
    override_until { rand(30).days.since }
  end

  trait :expired_within_grace_period do
    expiration_date { DoctorsNote.grace_period + rand(3).days }
  end

  trait :expiring_soon do
    expiration_date { rand(7).days.since }
  end

  trait :expired do
    expiration_date { Date.today + rand(30).days }
  end
end
