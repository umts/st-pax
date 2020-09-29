# frozen_string_literal: true

class PassengersController < ApplicationController
  before_action :find_passenger,
                only: %i[show edit update destroy set_status]
  before_action :restrict_to_admin, only: %i[destroy]
  skip_before_action :restrict_to_employee, only: %i[brochure]

  SMTP_ERROR_APPENDIX = 'but we could not notify them of their status change.'

  def archived
    @passengers =
      Passenger.archived.includes(:eligibility_verification, :mobility_device)
  end

  def brochure; end

  def set_status
    begin
      if @passenger.set_status(params[:status])
        flash[:success] = 'Passenger successfully updated'
        redirect_to passengers_url
      else
        flash[:danger] = @passenger.errors.full_messages
        redirect_to edit_passenger_path(@passenger)
      end
    rescue Net::SMTPFatalError
      flash[:warning] = "Passenger successfully updated, #{SMTP_ERROR_APPENDIX}"
      redirect_to passengers_url
    end
  end

  def check_existing
    @passenger = Passenger.find_by(spire: params[:spire_id])
    return unless @passenger.present?

    render partial: 'check_existing'
  end

  def new
    @passenger = Passenger.new(active_status: 'active')
    @verification = EligibilityVerification.new
  end

  def edit
    @verification = @passenger.eligibility_verification || EligibilityVerification.new
  end

  def index
    @passengers = Passenger.where(active_status: ['active', 'pending'])
      .includes(:eligibility_verification, :mobility_device).order :name
    allowed_filters = %w[permanent temporary]
    @filter = allowed_filters.find { |f| f == params[:filter] } || 'all'

    respond_to do |format|
      format.html
      format.pdf { passenger_pdf }
    end
  end

  def create
    @passenger = Passenger.new(passenger_params)
    @passenger.registerer = @current_user
    begin
      if @passenger.save
        flash[:success] = 'Passenger successfully created.'
        redirect_to @passenger
      else
        flash.now[:danger] = @passenger.errors.full_messages
        render :new
      end
    rescue Net::SMTPFatalError
      flash[:warning] = "Passenger successfully created, #{SMTP_ERROR_APPENDIX}"
      redirect_to @passenger
    end
  end

  def update
    @passenger.assign_attributes passenger_params
    begin
      if @passenger.save
        flash[:success] = 'Passenger successfully updated.'
        redirect_to @passenger
      else
        flash[:danger] = @passenger.errors.full_messages
        render :edit
      end
    rescue Net::SMTPFatalError
      flash[:warning] = "Passenger successfully updated, #{SMTP_ERROR_APPENDIX}"
      redirect_to @passenger
    end
  end

  def destroy
    @passenger.destroy
    flash[:success] = 'Passenger successfully destroyed.'
    redirect_to passengers_url
  end

  private

  def base_passenger_params
    passenger_params =
      params.require(:passenger)
            .permit(:name, :address, :email, :phone, :active_status,
                    :mobility_device_id, :permanent, :note, :spire,
                    :has_brochure,
                    eligibility_verification_attributes: %i[
                      expiration_date verifying_agency_id name address phone
                    ])
    passenger_params
  end

  def find_passenger
    @passenger = Passenger.find(params[:id])
  end

  def passenger_params
    base_passenger_params.then { |p| restrict_admin p }
  end

  def passenger_pdf
    @passengers = @passengers.send(@filter)
    pdf = PassengersPDF.new(@passengers, @filter)
    name = "#{@filter} Passengers #{Date.today}".capitalize
    send_data pdf.render, filename: name,
                          type: 'application/pdf',
                          disposition: :inline
  end

  def restrict_admin(permitted_params)
    return permitted_params if @current_user.admin?

    permitted_params.except :permanent
  end
end
