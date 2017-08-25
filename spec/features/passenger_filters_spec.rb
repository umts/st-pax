require 'rails_helper'

feature 'Passenger Filters' do 
  before :each do 
    when_current_user_is :admin
  end
  scenario 'permanent filter' do 
    create :passenger, :temporary
    create :passenger, :permanent
    visit passengers_url
    choose('filter_Permanent')
    click_on('Show Passengers')
    expect(page).to have_selector('table#passengers tbody tr', count: 1)
  end
  scenario 'temporary filter' do 
    create :passenger, :permanent
    create :passenger, :temporary
    visit passengers_url
    choose('filter_Temporary')
    click_on('Show Passengers')
    expect(page).to have_selector('table#passengers tbody tr', count: 1)
  end
  scenario 'all filter' do 
    create :passenger, :temporary
    create :passenger, :permanent
    visit passengers_url
    choose('filter_')
    click_on('Show Passengers')
    expect(page).to have_selector('table#passengers tbody tr', count: 2)
  end
  scenario 'active filter' do 
    create :passenger
    create :passenger, :inactive
    visit passengers_url
    uncheck('show_inactive')
    click_on('Show Passengers')
    expect(page).to have_selector('table#passengers tbody tr', count: 1)
  end
  scenario 'inactive filter' do 
    create :passenger
    create :passenger, :inactive
    visit passengers_url
    check('show_inactive')
    click_on('Show Passengers')
    expect(page).to have_selector('table#passengers tbody tr', count: 1)
  end 
end