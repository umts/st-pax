# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passenger Filters' do
  before :each do
    when_current_user_is :admin
  end
  it 'allows filtering by permanent status' do
    create :passenger, :temporary, :active, name: 'Gary Stue'
    create :passenger, :permanent, :active, name: 'Mary Sue'
    visit passengers_url
    choose 'Permanent'
    click_on 'Show Passengers'
    expect(page).to have_selector 'table#passengers tbody tr', count: 1
    expect(page).to have_content 'Mary Sue'
    expect(page).not_to have_content 'Gary Stue'
  end
  it 'allows filtering by temporary' do
    create :passenger, :temporary, :active, name: 'Gary Stue'
    create :passenger, :permanent, :active, name: 'Mary Sue'
    visit passengers_url
    choose 'Temporary'
    click_on 'Show Passengers'
    expect(page).to have_selector 'table#passengers tbody tr', count: 1
    expect(page).not_to have_content 'Mary Sue'
    expect(page).to have_content 'Gary Stue'
  end
  it 'allows filtering by everyone' do
    create :passenger, :temporary, :active, name: 'Gary Stue'
    create :passenger, :permanent, :active, name: 'Mary Sue'
    visit passengers_url
    choose 'All'
    click_on 'Show Passengers'
    expect(page).to have_selector 'table#passengers tbody tr', count: 2
    expect(page).to have_content 'Mary Sue'
    expect(page).to have_content 'Gary Stue'
  end
  it 'allows printing a PDF with filters' do
    visit passengers_url
    choose 'Permanent'
    create :passenger, :permanent, :active, name: 'Spongebob'
    click_on 'Print filtered list'
    analysis = PDF::Inspector::Text.analyze(page.body)
    expect(analysis.strings).to include 'Name'
    expect(analysis.strings).to include 'Spongebob'
  end
end
