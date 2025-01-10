# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Mobility Devices' do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let(:pax) { create(:passenger) }

  describe 'GET /mobility_devices' do
    subject(:call) { get '/mobility_devices' }

    context 'when logged in as admin' do
      before { login_as admin }

      it 'responds successfully' do
        call
        expect(response).to be_successful
      end
    end

    context 'when logged in as a user' do
      before { login_as user }

      it 'responds with an unauthorized status' do
        call
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when logged in as a passenger' do
      before { login_as_passenger pax }

      it 'responds with an unauthorized status' do
        call
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when not logged in' do
      it 'responds with an unauthorized status' do
        call
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'GET /mobility_devices/new' do
    subject(:call) { get '/mobility_devices/new' }

    context 'when logged in as admin' do
      before { login_as admin }

      it 'responds successfully' do
        call
        expect(response).to be_successful
      end
    end

    context 'when logged in as a user' do
      before { login_as user }

      it 'responds with an unauthorized status' do
        call
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when logged in as a passenger' do
      before { login_as_passenger pax }

      it 'responds with an unauthorized status' do
        call
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'POST /mobility_devices' do
    subject(:submit) { post '/mobility_devices', params: }

    let(:params) { { mobility_device: { name: 'Scooter', needs_longer_rides: true } } }

    context 'when logged in as admin' do
      before { login_as admin }

      context 'with valid params' do
        it 'creates a new mobility device' do
          expect { submit }.to change(MobilityDevice, :count).by(1)
        end

        it 'creates a new mobility device with the right attributes' do
          submit
          expect(MobilityDevice.last).to have_attributes({ name: 'Scooter',
                                                           needs_longer_rides: true })
        end

        it 'redirects to the index' do
          submit
          expect(response).to redirect_to mobility_devices_url
        end
      end

      context 'when the device already exists' do
        before { submit }

        let(:copy_params) { { mobility_device: { name: 'sCoOtEr', needs_longer_rides: false } } }

        it 'does not create a new device' do
          expect { post '/mobility_devices', params: copy_params }.not_to change(MobilityDevice, :count)
        end

        it 'returns an unprocessable entity status' do
          post '/mobility_devices', params: copy_params
          expect(response).to have_http_status :unprocessable_entity
        end
      end

      context 'with invalid params' do
        let(:bad_params) { { mobility_device: { name: nil, needs_longer_rides: 'true' } } }

        it 'does not create a new device' do
          expect { post '/mobility_devices', params: bad_params }.not_to change(MobilityDevice, :count)
        end

        it 'returns an unprocessable entity status' do
          post '/mobility_devices', params: bad_params
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end

    context 'when logged in as a user' do
      before { login_as user }

      it 'does not create a new device' do
        expect { submit }.not_to change(MobilityDevice, :count)
      end

      it 'returns an unauthorized status' do
        submit
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when logged in as a pax' do
      before { login_as_passenger pax }

      it 'does not create a new device' do
        expect { submit }.not_to change(MobilityDevice, :count)
      end

      it 'returns an unauthorized status' do
        submit
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when not logged in' do
      it 'does not create a new device' do
        expect { submit }.not_to change(MobilityDevice, :count)
      end

      it 'returns an unauthorized status' do
        submit
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
