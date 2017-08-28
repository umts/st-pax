# frozen_string_literal: true

class PassengersController < ApplicationController
  before_action :find_passenger, only: %i[show edit update destroy]
  before_action :access_control, only: %i[destroy]
  def new
    @passenger = Passenger.new
    @doctors_note = DoctorsNote.new
  end

  def edit
    @doctors_note = @passenger.doctors_note || DoctorsNote.new
  end

  def index
    @passengers = Passenger.order :name
    @filters = []
    filter = params[:filter]
    if %w[Permanent Temporary].include? filter
      @passengers = @passengers.send filter.downcase
      @filters << filter
    else @filters << 'All'
    end
    unless params[:show_inactive]
      @passengers = @passengers.active
      @filters << 'Active'
    end
  end

  def create
    @passenger = Passenger.new(passenger_params)
    if @passenger.save
      redirect_to @passenger, notice: 'Passenger was successfully created.'
    else
      render :new
    end
  end

  def update
    if @passenger.update(passenger_params)
      redirect_to @passenger, notice: 'Passenger was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @passenger.destroy
    redirect_to passengers_url, notice: 'Passenger was successfully destroyed.'
  end

  private

  def passenger_params
    permitted_params = params.require(:passenger)
                             .permit :name, :address, :email, :phone,
                                     :wheelchair, :mobility_device, :active,
                                     :permanent, :note,
                                     doctors_note_attributes: [:expiration_date]
    unless @current_user.admin?
      permitted_params = permitted_params.except(:active, :permanent)
    end
    permitted_params
  end

  def find_passenger
    @passenger = Passenger.find(params[:id])
  end
end
