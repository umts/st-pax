# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    name  { FFaker::Name.name }
    phone { FFaker::PhoneNumber.short_phone_number }
    sequence(:spire) { |n| n.to_s.rjust(8, '0') + '@umass.edu' }
    active true
  end

  trait :admin do
    admin true
  end
end
