class PassengersController < ApplicationController
  def new
    @passenger = Passenger.new
  end

  def index
    @passengers = Passenger.all
  end

  def show
    @passenger = Passenger.find(params[:id])
  end

  def edit
    @passenger = Passenger.find(params[:id])
  end

  def create
    passenger = Passenger.new(passenger_params)
    if passenger.save
      flash[:beans] = "Passenger has been created."
    else
      flash[:tacos] = passenger.errors.full_messages.to_sentence
    end
    redirect_to passengers_path
  end

  def update
    passenger = Passenger.find(params[:id])
    if passenger.update passenger_params
      flash[:notice] = "Passenger has been updated"
    else
      flash[:notice] = passenger.errors.full_messages.to_sentence
    end
  end

  def destroy
    passenger = Passenger.find(params[:id])
    passenger.destroy
    flash[:notice] = "Passenger has been deleted"
    redirect_to action: 'index'
  end

  private

  def passenger_params
    params.require(:passenger).permit(:name, :address, :email, :phone,
      :wheelchair, :active, :permanent, :note)
  end
end
