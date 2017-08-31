# frozen_string_literal: true

class MobilityDevicesController < ApplicationController
  before_action :set_device, only: %i[destroy edit update]

  def create
    @device = MobilityDevice.new(device_params)

    if @device.save
      redirect_to mobility_devices_url,
                  notice: 'Mobility device was successfully created.'
    else render :new
    end
  end

  def destroy
    @device.destroy
    redirect_to mobility_devices_url,
                notice: 'Mobility device was successfully destroyed.'
  end

  def index
    @devices = MobilityDevice.order :name
  end

  def new
    @device = MobilityDevice.new
  end

  def update
    if @device.update(device_params)
      redirect_to mobility_devices_url,
                  notice: 'Mobility device was successfully updated.'
    else render :edit
    end
  end

  private

  def set_device
    @device = MobilityDevice.find_by id: params.require(:id)
    head :not_found unless @device.present?
  end

  def device_params
    params.require(:mobility_device).permit :name, :needs_longer_rides
  end
end
