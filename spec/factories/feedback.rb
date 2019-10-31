# frozen_string_literal: true

FactoryBot.define do
  factory :feedback do
    title { 'Site problem' }
    category { 'bug' }
  end
end
