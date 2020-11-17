# frozen_string_literal: true

class CarriersController < ApplicationController
  before_action :set_carrier, only: %i[edit update destroy]

  def index
    @carriers = Carrier.order :name
  end

  def new
    @carrier = Carrier.new
  end

  def create
    @carrier = Carrier.new(carrier_params)

    if @carrier.save
      flash[:success] = 'Carrier successfully created'
      redirect_to carriers_url
    else
      flash.now[:danger] = @carrier.errors.full_messages
      render :new
    end
  end

  def update
    if @carrier.update(carrier_params)
      flash[:success] = 'Carrier successfully updated'
      redirect_to carriers_url
    else
      flash.now[:danger] = @carrier.errors.full_messages
      render :edit
    end
  end

  def destroy
    if @carrier.destroy
      flash[:success] = 'Carrier successfully destroyed.'
    else
      flash[:danger] = @carrier.errors.full_messages
    end
    redirect_to carriers_url
  end

  private

  def set_carrier
    @carrier = Carrier.find(params[:id])
  end

  def carrier_params
    params.require(:carrier).permit(:name, :gateway_address)
  end
end
