require 'rails_helper'

feature 'Passenger Filters' do 
  before :each do 
    when_current_user_is :admin
  end
  scenario 'permanent filter' do 
    create :passenger
    create :passenger, :permanent
    visit passengers_url
    choose('filter_permanent')
    click_on('Find passengers')
    expect(page).to have_selector('table#passengers tbody tr', count: 1)
  end
  scenario 'temporary filter' do 
    create :passenger, :permanent
    create :passenger
    visit passengers_url
    choose('filter_temporary')
    click_on('Find passengers')
    expect(page).to have_selector('table#passengers tbody tr', count: 1)
  end
  scenario 'inactive filter' do 
    create :passenger
    create :passenger, :inactive
    visit passengers_url
    choose('filter_inactive')
    click_on('Find passengers')
    expect(page).to have_selector('table#passengers tbody tr', count: 1)
  end
  scenario 'only active filter' do 
    create :passenger
    create :passenger, :inactive
    visit passengers_url
    choose('filter_active')
    click_on('Find passengers')
    expect(page).to have_selector('table#passengers tbody tr', count: 1)
  end
  scenario 'show all filter' do 
    create :passenger
    create :passenger
    visit passengers_url
    choose('filter_all')
    click_on('Find passengers')
    expect(page).to have_selector('table#passengers tbody tr', count: 2)
  end
end