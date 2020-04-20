# frozen_string_literal: true

FactoryBot.define do
  factory :verifying_agency do
    sequence(:name) { |n| "Name#{n}" }
  end
end
