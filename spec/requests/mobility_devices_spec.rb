# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Mobility Devices' do
  shared_context 'with admin login' do
    let(:admin) { create(:user, :admin) }

    before { login_as admin }
  end

  shared_context 'with user login' do
    let(:user) { create(:user) }

    before { login_as user }
  end

  shared_context 'with pax login' do
    let(:pax) { create(:passenger) }

    before { login_as_passenger pax }
  end

  describe 'GET /mobility_devices' do
    subject(:call) { get '/mobility_devices' }

    context 'when logged in as admin' do
      include_context 'with admin login'

      it 'responds successfully' do
        call
        expect(response).to be_successful
      end
    end

    context 'when logged in as a user' do
      include_context 'with user login'

      it 'responds with an unauthorized status' do
        call
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when logged in as a passenger' do
      include_context 'with pax login'

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
      include_context 'with admin login'

      it 'responds successfully' do
        call
        expect(response).to be_successful
      end
    end

    context 'when logged in as a user' do
      include_context 'with user login'

      it 'responds with an unauthorized status' do
        call
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when logged in as a passenger' do
      include_context 'with pax login'

      it 'responds with an unauthorized status' do
        call
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when not logged in' do
      it 'respond with an unauthorized status' do
        call
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'POST /mobility_devices' do
    subject(:submit) { post '/mobility_devices', params: { mobility_device: attributes } }

    let(:attributes) { { name: 'Scooter', needs_longer_rides: true } }

    context 'when logged in as admin' do
      include_context 'with admin login'

      context 'with valid params' do
        it 'creates a new mobility device' do
          expect { submit }.to change(MobilityDevice, :count).by(1)
        end

        it 'creates a new mobility device with the right attributes' do
          submit
          expect(MobilityDevice.last).to have_attributes(attributes)
        end

        it 'redirects to the index' do
          submit
          expect(response).to redirect_to mobility_devices_url
        end
      end

      context 'when a device already exists with the same name' do
        before { create(:mobility_device, name: 'sCoOtEr', needs_longer_rides: false) }

        it 'does not create a new device' do
          expect { submit }.not_to change(MobilityDevice, :count)
        end

        it 'returns an unprocessable entity status' do
          submit
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
      include_context 'with user login'

      it 'does not create a new device' do
        expect { submit }.not_to change(MobilityDevice, :count)
      end

      it 'returns an unauthorized status' do
        submit
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when logged in as a pax' do
      include_context 'with pax login'

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

  describe 'GET /mobility_devices/:id/edit' do
    subject(:call) { get "/mobility_devices/#{device.id}/edit" }

    let(:device) { create(:mobility_device) }

    context 'when logged in as an admin' do
      include_context 'with admin login'

      it 'responds successfully' do
        call
        expect(response).to be_successful
      end
    end

    context 'when logged in as a user' do
      include_context 'with user login'

      it 'responds with an unauthorized status' do
        call
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when logged in as a passenger' do
      include_context 'with pax login'

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

  describe 'PATCH /mobility_devices/:id' do
    subject(:submit) { patch "/mobility_devices/#{device.id}", params: { mobility_device: attributes } }

    let(:device) { create(:mobility_device) }
    let(:attributes) { { name: 'Walker', needs_longer_rides: true } }

    context 'when logged in as an admin' do
      include_context 'with admin login'

      context 'with valid params' do
        it 'updates the device' do
          expect { submit }.to(change { device.reload.attributes })
        end

        it 'correctly changes the attributes' do
          submit
          expect(device.reload).to have_attributes(attributes)
        end

        it 'redirects to the index' do
          submit
          expect(response).to redirect_to mobility_devices_url
        end
      end

      context 'when a device already exists with the same name' do
        before { create(:mobility_device, name: 'wAlKeR', needs_longer_rides: false) }

        it 'does not change the device' do
          expect { submit }.not_to(change { device.reload.attributes })
        end

        it 'returns an unprocessable entity status' do
          submit
          expect(response).to have_http_status :unprocessable_entity
        end
      end

      context 'with invalid params' do
        let(:bad_params) { { mobility_device: { name: nil, needs_longer_rides: 'true' } } }

        it 'does not update the device' do
          expect { patch "/mobility_devices/#{device.id}", params: bad_params }
            .not_to(change { device.reload.attributes })
        end

        it 'returns an unprocessable entity status' do
          patch "/mobility_devices/#{device.id}", params: bad_params
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end

    context 'when logged in as a user' do
      include_context 'with user login'

      it 'does change the device' do
        expect { submit }.not_to(change { device.reload.attributes })
      end

      it 'responds with an unauthorized status' do
        submit
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when logged in as a pax' do
      include_context 'with pax login'

      it 'does change the device' do
        expect { submit }.not_to(change { device.reload.attributes })
      end

      it 'responds with an unauthorized status' do
        submit
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when not logged in' do
      it 'does change the device' do
        expect { submit }.not_to(change { device.reload.attributes })
      end

      it 'responds with an unauthorized status' do
        submit
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'DELETE /mobility_devices/:id' do
    subject(:call) { delete "/mobility_devices/#{device.id}" }

    let!(:device) { create(:mobility_device) }

    context 'when logged in as admin' do
      include_context 'with admin login'

      context 'with no pax are dependent on the device' do
        it 'destroys the device' do
          expect { call }.to change(MobilityDevice, :count).by(-1)
        end

        it 'cannot be retrieved anymore' do
          call
          expect(MobilityDevice.find_by(id: device.id)).to be_nil
        end

        it 'redirects to the index' do
          call
          expect(response).to redirect_to mobility_devices_url
        end
      end

      context 'with a pax is dependent on the device' do
        let!(:dependent) { create(:passenger) }
        let!(:used_device) { create(:mobility_device, passengers: [dependent]) }

        it 'does not destroy the device' do
          expect { delete "/mobility_devices/#{used_device.id}" }.not_to change(MobilityDevice, :count)
        end

        it 'can still be retrieved' do
          delete "/mobility_devices/#{used_device.id}"
          expect(MobilityDevice.find_by(id: device.id)).not_to be_nil
        end

        it 'redirects to the index' do
          delete "/mobility_devices/#{used_device.id}"
          expect(response).to redirect_to mobility_devices_url
        end
      end
    end

    context 'when logged in as a user' do
      include_context 'with user login'

      it 'does not destroy the device' do
        expect { call }.not_to change(MobilityDevice, :count)
      end

      it 'can still be retrieved' do
        call
        expect(MobilityDevice.find_by(id: device.id)).not_to be_nil
      end

      it 'responds with an unauthorized status' do
        call
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when logged in as a passenger' do
      include_context 'with pax login'

      it 'does not destroy the device' do
        expect { call }.not_to change(MobilityDevice, :count)
      end

      it 'can still be retrieved' do
        call
        expect(MobilityDevice.find_by(id: device.id)).not_to be_nil
      end

      it 'responds with an unauthorized status' do
        call
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when not logged in' do
      it 'does not destroy the device' do
        expect { call }.not_to change(MobilityDevice, :count)
      end

      it 'can still be retrieved' do
        call
        expect(MobilityDevice.find_by(id: device.id)).not_to be_nil
      end

      it 'responds with an unauthorized status' do
        call
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
