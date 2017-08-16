FactoryGirl.define do 
  factory :passenger do 
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
  end
end