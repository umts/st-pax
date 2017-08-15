FactoryGirl.define do 
  factory :user do 
    sequence(:name) {|n| "Name #{n}"}
    sequence(:email) {|n| "test#{n}@example.com"}
    sequence(:spire) {|n| n.to_s.rjust(8,'0')}
  end

  trait :admin do 
    admin true
  end
end