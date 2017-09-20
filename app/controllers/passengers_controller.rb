# frozen_string_literal: true

class PassengersController < ApplicationController
  before_action :find_passenger, only: [:show, :edit, :update, :destroy]
  before_action :access_control, only: [:destroy]

  def new
    @passenger = Passenger.new
    @doctors_note = DoctorsNote.new
  end

  def edit
    @doctors_note = @passenger.doctors_note || DoctorsNote.new
  end

  # rubocop:disable Style/GuardClause
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
  # rubocop:enable Style/GuardClause

  def create
    @passenger = Passenger.new(passenger_params)
    @passenger.registered_by = @current_user
    if @passenger.save
      redirect_to @passenger, notice: 'Passenger was successfully created.'
    else render :new
    end
  end

  def update
    if @passenger.update(passenger_params)
      @passenger.doctors_note.update_attributes(overridden_by: @current_user)
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
                                     :wheelchair, :mobility_device_id, :active,
                                     :permanent, :note,
                                     :permanent, :note, :spire, :status,
                                     :has_brochure,
                                     :registered_with_disability_services,
                                     doctors_note_attributes: [:expiration_date,
                                                                 :override_expiration,
                                                                 :override_until]
    unless @current_user.admin?
      permitted_params = permitted_params.except(:active, :permanent)
    end
    note_params = permitted_params[:doctors_note_attributes]
    if note_params.try(:[], :expiration_date).blank?
      permitted_params.delete :doctors_note_attributes
    end
    permitted_params
  end

  def find_passenger
    @passenger = Passenger.find(params[:id])
  end
end
