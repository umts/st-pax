# frozen_string_literal: true

FactoryGirl.define do
  factory :mobility_device do
    sequence(:device) { |n| "Device #{n}" }
    needs_longer_rides { [true, false].sample }
  end
end
