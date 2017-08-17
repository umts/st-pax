require 'rails_helper' 

feature 'Passenger Management' do 
  before :each do
    sign_in(create :user, :admin) 
  end
  scenario 'creating a new passenger' do 
    visit passengers_path
  end
  scenario 'editing an existing passenger' do 
    passenger = create :passenger
    visit passengers_path
  end
  scenario 'viewing an existing passenger' do 
    passenger = create :passenger
    visit passengers_path
  end
  scenario 'deleting an existing passenger' do 
    passenger = create :passenger
    visit passengers_path
  end
end