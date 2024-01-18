# frozen_string_literal: true

class MobilityDevicesController < ApplicationController
  before_action :set_device, only: %i[destroy edit update]
  before_action :restrict_to_admin

  def index
    @devices = MobilityDevice.order :name
  end

  def new
    @device = MobilityDevice.new
  end

  def edit; end

  def create
    @device = MobilityDevice.new(device_params)

    if @device.save
      flash[:success] = t('.success')
      redirect_to mobility_devices_url
    else
      flash.now[:danger] = @device.errors.full_messages
      render :new
    end
  end

  def update
    if @device.update(device_params)
      flash[:success] = t('.success')
      redirect_to mobility_devices_url
    else
      flash.now[:danger] = @device.errors.full_messages
      render :edit
    end
  end

  def destroy
    if @device.destroy
      flash[:success] = t('.success')
    else
      flash[:danger] = @device.errors.full_messages
    end
    redirect_to mobility_devices_url
  end

  private

  def set_device
    @device = MobilityDevice.find_by id: params.require(:id)
    head :not_found if @device.blank?
  end

  def device_params
    params.require(:mobility_device).permit :name, :needs_longer_rides
  end
end
