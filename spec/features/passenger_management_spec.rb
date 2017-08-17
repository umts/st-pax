require 'rails_helper' 

feature 'Passenger Management' do 
  before :each do
    sign_in(create :user, :admin)
  end
  scenario 'creating a new passenger' do 
    visit passengers_path
    click_link 'Add New Passenger'
    fill_in('passenger[name]', with: 'Foo Bar')
    fill_in('passenger[email]', with: 'foobar@invalid.com')
    click_button('Submit')
    expect(page).to have_text('Passenger was successfully created.')
  end
  scenario 'editing an existing passenger' do 
    passenger = create :passenger
    visit passengers_path
    click_link 'Edit'
    check('passenger_permanent')
    click_button('Submit')
    expect(page).to have_text('Passenger was successfully updated.')
  end
  scenario 'deleting an existing passenger' do 
    passenger = create :passenger
    visit passengers_path
    click_link 'Delete'
    expect(page).to have_text('Passenger was successfully destroyed.')
  end
end