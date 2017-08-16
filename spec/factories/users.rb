FactoryGirl.define do 
  factory :user do 
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    sequence(:spire) {|n| n.to_s.rjust(8,'0')}
  end

  trait :admin do 
    admin true
  end
end