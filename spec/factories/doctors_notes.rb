# frozen_string_literal: true

FactoryGirl.define do
  factory :doctors_note do
    association :passenger
    override_expiration false
  end

  trait :overriden do
    override_expiration true
    # TODO: I think this should be defined as a real association.
    overriden_by 1
    override_until { rand(30).days.since }
  end
end
