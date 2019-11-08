# frozen_string_literal: true

FactoryBot.define do
  factory :verification_source do
    sequence(:name) { |n| "Service #{n}" }
  end
end
