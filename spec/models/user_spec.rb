# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe '#dispatcher?' do
    it 'is the inverse of admin?' do
      expect(create(:user, :admin).dispatcher?).to be false
    end
  end

  describe '#can_modify?' do
    let(:call) { user.can_modify? @item }

    context 'when user is an admin' do
      let(:user) { create :user, :admin }

      it 'returns true' do
        @item = create :log_entry
        expect(call).to be true
      end
    end

    context 'when user is a dispatcher' do
      let(:user) { create :user }

      context 'with a log entry' do
        it 'returns false if it is not associated with the user' do
          @item = create :log_entry
          expect(call).to be false
        end
        it 'returns true if it is associated with the user' do
          @item = create(:log_entry, user:)
          expect(call).to be true
        end
      end

      it 'returns false with something other than a log entry' do
        @item = create :passenger
        expect(call).to be false
      end
    end
  end
end
