# frozen_string_literal: true

FactoryGirl.define do
  factory :mobility_device do
    device { FFaker::Lorem.word }
    lift_ramp false
  end
end
