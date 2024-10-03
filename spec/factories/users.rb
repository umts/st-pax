# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name  { Faker::Name.name }
    sequence(:spire) { |n| format('%08i@umass.edu', n) }
    active { true }
  end

  trait :admin do
    admin { true }
  end
end
