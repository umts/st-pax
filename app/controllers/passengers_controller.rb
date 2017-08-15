class PassengersController < ApplicationController
  before_action :find_passenger, only: %i[show edit update destroy]
  before_action :access_control, only: %i[destroy]
  def new
    @passenger = Passenger.new
    @doctors_note = DoctorsNote.new
  end

  def edit
    if @passenger.doctors_note.present?
      @doctors_note = @passenger.doctors_note
    else
      @doctors_note = DoctorsNote.new
    end
  end

  # TODO: refactor

  def index
    @permanent = params[:filter] == 'permanent'
    @temporary = params[:filter] == 'temporary'
    @inactive = params[:filter] == 'inactive'
    @active = params[:filter] == 'active'
    @passengers = Passenger.order :name
    @passengers = @passengers.permanent if @permanent
    @passengers = @passengers.temporary if @temporary
    @passengers = @passengers.inactive if @inactive
    @passengers = @passengers.active if @active
  end

  def create
    @passenger = Passenger.new(passenger_params)
    @passenger.doctors_note = DoctorsNote.new(params[:doctors_note])
    if @passenger.save
      redirect_to @passenger, notice: 'Passenger was successfully created.'
    else
      render :new
    end
  end

  def update
    if @passenger.update(passenger_params)
      if @passenger.doctors_note.present?
        @passenger.doctors_note.update(params[:doctors_note])
      else
        @passenger.doctors_note = DoctorsNote.create(params[:doctors_note])
      end
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
                             .permit(:name, :address, :email, :phone,
                                     :wheelchair, :mobility_device, :active,
                                     :permanent, :note, doctors_note_attributes: [:expiration_date])
    doctors_note_attrs = permitted_params[:doctors_note_attributes]
    unless doctors_note_attrs[:expiration_date].present?
      permitted_params.delete :doctors_note_attributes
    end
    unless @current_user.admin?
      permitted_params = permitted_params.except(:active, :permanent)
    end
    permitted_params
  end

  def find_passenger
    @passenger = Passenger.find(params[:id])
  end
end
