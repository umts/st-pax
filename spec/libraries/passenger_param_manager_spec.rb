# frozen_string_literal: true

require 'rails_helper'
require 'passenger_param_manager'

RSpec.describe PassengerParamManager do
  describe '#params' do
    subject(:call) { described_class.new(params, env, current_user).params }

    let(:params) do
      ActionController::Parameters.new(
        passenger: { note: 'A note',
                     permanent: true,
                     spire: '45645678@umass.edu',
                     name: 'Alice Anderson',
                     eligibility_verification_attributes: { name: 'An office' } }
      )
    end
    let(:env) { {} }
    let(:current_user) { create(:user, :admin) }

    it 'requires passenger params' do
      params.delete(:passenger)
      expect { call }.to raise_exception(ActionController::ParameterMissing)
    end

    it 'permits passenger params' do
      expect(call).to be_permitted
    end

    it 'permits eligibility verification params' do
      expect(call[:eligibility_verification_attributes]).to be_permitted
    end

    it 'does not merge in values from env by default' do
      expect(call['name']).to eq('Alice Anderson')
    end

    context 'when the current user is not an admin' do
      let(:current_user) { create(:user) }

      it 'forbids updating permanent status' do
        expect(call.keys).not_to include('permanent')
      end
    end

    context 'when there is not a current user' do
      let(:current_user) { nil }
      let(:env) do
        { 'fcIdNumber' => '12123434@umass.edu',
          'givenName' => 'Katherine',
          'surName' => 'Katrinova' }
      end

      it 'merges in spire from env' do
        expect(call['spire']).to eq('12123434@umass.edu')
      end

      it 'merges in name from env' do
        expect(call['name']).to eq('Katherine Katrinova')
      end
    end
  end
end
