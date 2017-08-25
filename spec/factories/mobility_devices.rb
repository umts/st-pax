# frozen_string_literal: true

FactoryGirl.define do
  factory :mobility_device do
    sequence(:device) { |n| "Device #{n}" }
    lift_ramp { [true, false].sample }
  end
end
