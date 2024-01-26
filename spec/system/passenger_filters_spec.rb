# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passenger Filters' do
  let!(:temp_pax) { create(:temporary_passenger, name: 'Gary Stue') }
  let!(:perm_pax) { create(:passenger, :permanent, name: 'Mary Sue') }

  before do
    when_current_user_is :admin
    visit passengers_path
  end

  context 'when using the HTML view', :js do
    context 'when filtering by permanent passengers' do
      before { choose 'Permanent' }

      it 'shows the correct number of passengers' do
        expect(page).to have_css 'table#passengers tbody tr', count: 1
      end

      it 'shows permanent passengers' do
        expect(page).to have_content(perm_pax.name)
      end

      it "doesn't show temporary passengers" do
        expect(page).to have_no_content(temp_pax.name)
      end
    end

    context 'when filtering by temporary passengers' do
      before { choose 'Temporary' }

      it 'shows the correct number of passengers' do
        expect(page).to have_css 'table#passengers tbody tr', count: 1
      end

      it 'shows temporary passengers' do
        expect(page).to have_content(temp_pax.name)
      end

      it "doesn't show permament passengers" do
        expect(page).to have_no_content(perm_pax.name)
      end
    end

    context 'when filtering by all passengers' do
      before { choose 'All' }

      it 'shows the correct number of passengers' do
        expect(page).to have_css 'table#passengers tbody tr', count: 2
      end

      it 'shows permanent passengers' do
        expect(page).to have_content(perm_pax.name)
      end

      it 'shows temporary passengers' do
        expect(page).to have_content(temp_pax.name)
      end
    end
  end

  context 'when using the PDF view' do
    let(:content) { PDF::Inspector::Text.analyze(page.body) }

    context 'when filtering by permanent passengers' do
      before do
        choose 'Permanent'
        click_on 'Print'
      end

      it 'shows permanent passengers' do
        expect(content.strings).to include(perm_pax.name)
      end

      it "doesn't show temporary passengers" do
        expect(content.strings).not_to include(temp_pax.name)
      end
    end

    context 'when filtering by temporary passengers' do
      before do
        choose 'Temporary'
        click_on 'Print'
      end

      it 'shows temporary passengers' do
        expect(content.strings).to include(temp_pax.name)
      end

      it "doesn't show permament passengers" do
        expect(content.strings).not_to include(perm_pax.name)
      end
    end

    context 'when filtering by all passengers' do
      before do
        choose 'All'
        click_on 'Print'
      end

      it 'shows permanent passengers' do
        expect(content.strings).to include(perm_pax.name)
      end

      it 'shows temporary passengers' do
        expect(content.strings).to include(temp_pax.name)
      end
    end
  end
end
