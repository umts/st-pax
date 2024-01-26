# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe '#dispatcher?' do
    it 'is the inverse of admin?' do
      expect(create(:user, :admin).dispatcher?).to be false
    end
  end

  describe '#can_modify?' do
    subject(:call) { user.can_modify? item }

    context 'when user is an admin' do
      let(:user) { create(:user, :admin) }
      let(:item) { create(:log_entry) }

      it { is_expected.to be(true) }
    end

    context 'when user is a dispatcher' do
      let(:user) { create(:user) }

      context "with another user's log entry" do
        let(:item) { create(:log_entry) }

        it { is_expected.to be(false) }
      end

      context "with the user's log entry" do
        let(:item) { create(:log_entry, user:) }

        it { is_expected.to be(true) }
      end

      context 'with something other than a log entry' do
        let(:item) { create(:passenger) }

        it { is_expected.to be(false) }
      end
    end
  end
end
