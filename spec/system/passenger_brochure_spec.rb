# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passenger Brochure' do
  let!(:staff_member) { create(:user, title: 'Admiral') }
  let!(:non_staff_member) { create(:user) }
  let!(:inactive_staff_member) { create(:user, active: false, title: 'Grand Poobah') }

  before { visit brochure_passengers_path }

  it 'shows users with titles' do
    expect(page).to have_text(/Admiral\s+#{staff_member.name}/)
  end

  it "doesn't show users without titles" do
    expect(page).to have_no_text(non_staff_member.name)
  end

  it "doesn't show inactive users" do
    expect(page).to have_no_text(inactive_staff_member.name)
  end

  context 'with multiple users with the same title' do
    let!(:second_staff_member) { create(:user, title: 'Admiral') }

    before { visit brochure_passengers_path }

    it 'pluralizes titles with more than one user' do
      expect(page).to have_text('Admirals')
    end

    it 'combines users with the same title' do
      expect(page).to have_text("#{staff_member.name} and #{second_staff_member.name}")
    end
  end
end
