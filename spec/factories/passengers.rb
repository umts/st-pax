FactoryGirl.define do 
  factory :passengers do 
    name FFaker::Name.name
    email FFaker::Internet.email
  end
end