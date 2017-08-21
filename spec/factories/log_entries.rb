FactoryGirl.define do
  factory :log_entry do
    user
    text { FFaker::Lorem.paragraph }
  end
end
