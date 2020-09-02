# frozen_string_literal: true

FactoryBot.define do
  factory :carrier do
    sequence(:name) { |n| "carrier#{n}" }
    gateway_address { "@#{name}.com" }
  end
end
