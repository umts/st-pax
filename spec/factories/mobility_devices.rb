# frozen_string_literal: true

FactoryGirl.define do
  factory :mobility_device do
    sequence(:name) { |n| "Device #{n}" }
    needs_longer_rides { [true, false].sample }
  end
end
