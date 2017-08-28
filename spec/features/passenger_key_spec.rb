# frozen_string_literal: true

require 'rails_helper'

feature 'Passenger Keys' do
  before :each do
    when_current_user_is :admin
  end
  scenario 'will expire in a week' do
    passenger = create :passenger, :expiring_soon
    visit passengers_url
    expect(page).to have_css('tr.will_expire_soon')
  end
  scenario 'recently expired' do
    passenger = create :passenger, :recently_expired
    visit passengers_url
    expect(page).to have_css('tr.expired_within_grace_period')
  end
  scenario 'overriden expiration' do
    passenger = create :passenger, :expiration_overriden
    visit passengers_url
    expect(page).to have_css('tr.has_been_overridden')
  end
  scenario 'Inactive' do
    passenger = create :passenger
    create :doctors_note, passenger: passenger,
                          expiration_date: 5.days.ago
    visit passengers_url
    expect(page).to have_css('tr.inactive')
  end
  scenario 'No Note' do
    passenger = create :passenger
    visit passengers_url
    expect(page).to have_css('tr.no_note')
  end
end
