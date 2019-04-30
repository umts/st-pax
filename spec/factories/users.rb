# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name  { FFaker::Name.name }
    sequence(:spire) { |n| n.to_s.rjust(8, '0') + '@umass.edu' }
    active { true }
  end

  trait :admin do
    admin { true }
  end
end
