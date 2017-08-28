# frozen_string_literal: true

FactoryGirl.define do
  factory :log_entry do
    user
    text { FFaker::Lorem.paragraph }
  end
end
