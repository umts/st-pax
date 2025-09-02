# frozen_string_literal: true

require 'passenger_param_manager'

class PassengersController < ApplicationController
  before_action :find_passenger, only: %i[show edit update destroy set_status]
  before_action :restrict_to_admin, only: %i[destroy]
  skip_before_action :require_authentication, only: :brochure
  skip_before_action :restrict_to_employee, only: %i[brochure welcome new edit create show register]

  def brochure; end

  def welcome
    redirect_to @current_user.present? ? passengers_path : register_passengers_path
  end

  def set_status
    success = -> { redirect_to passengers_path }
    failure = -> { redirect_to edit_passenger_path(@passenger) }

    try_notifying_passenger success:, failure:, success_message: t('.update.success') do
      @passenger.set_status(params[:status])
    end
  end

  def check_existing
    @passenger = Passenger.find_by(spire: params[:spire_id])
    return if @passenger.blank?

    render partial: 'check_existing'
  end

  def index
    status_filter = params[:status].presence || %w[active pending]
    @status = params[:status]&.to_sym
    allowed_filters = %w[permanent temporary]
    @filter = allowed_filters.find { |f| f == params[:filter] } || 'all'
    @passengers = Passenger.where(registration_status: status_filter)
                           .includes(:eligibility_verification, :mobility_device)
                           .order :name
    @passengers = @passengers.send(@filter)

    respond_to do |format|
      format.html
      format.pdf { passenger_pdf }
      format.csv do
        send_data @passengers.to_csv,
                  filename: "passengers-#{Time.zone.today}.csv",
                  type: 'text/csv; charset=utf-8',
                  disposition: 'attachment'
      end
    end
  end

  def show; end

  def new
    @passenger = if @current_user.present?
                   Passenger.new(registration_status: 'active')
                 elsif @registrant.present?
                   @registrant
                 end
    @verification = EligibilityVerification.new
  end

  def edit
    if @registrant.present? && !@registrant&.pending?
      flash[:warning] = t('.must_call', phone: t('department.phone'))
      redirect_to passenger_path(@registrant)
    end
    @verification = @passenger.eligibility_verification || EligibilityVerification.new
  end

  def register
    @passenger = @registrant
    if @passenger&.persisted?
      redirect_to action: :edit, id: @passenger.id
    else
      redirect_to action: :new
    end
  end

  def create
    @passenger = Passenger.new(passenger_params)
    @passenger.registerer = @current_user
    success = -> { redirect_to @passenger }
    failure = -> { render :new, status: :unprocessable_content }

    try_notifying_passenger success:, failure:, success_message: t('.success') do
      @passenger.save
    end
  end

  def update
    @passenger.assign_attributes passenger_params
    success = -> { redirect_to @passenger }
    failure = -> { render :edit, status: :unprocessable_content }

    try_notifying_passenger success:, failure:, success_message: t('.registrant_success') do
      @passenger.save
    end
  end

  def destroy
    @passenger.destroy
    flash[:success] = t('.success')
    redirect_to passengers_url
  end

  private

  def find_passenger
    @passenger = Passenger.find(params[:id])
  end

  def passenger_pdf
    pdf = PassengersPdf.new(@passengers, @filter)
    name = "#{@filter} Passengers #{Time.zone.today}".capitalize
    send_data pdf.render, filename: name,
                          type: 'application/pdf',
                          disposition: :inline
  end

  def passenger_params
    PassengerParamManager.new(params, request.env, @current_user).params
  end

  def try_notifying_passenger(success:, failure:, success_message:)
    if yield
      flash[:success] = success_message and success.call
    else
      flash[:danger] = @passenger.errors.full_messages and failure.call
    end
  rescue Net::SMTPFatalError
    flash[:warning] = t('.notify_warning', message: success_message)
    success.call
  end
end
