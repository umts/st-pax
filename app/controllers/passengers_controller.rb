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
    passenger = Passenger.new(params[:passenger])
    if passenger.save
      flash[:notice] = "Passenger has been created."
    else 
      flash[:error] = passenger.errors.full_messages.to_sentence
    end
  end
  
  def update
    passenger = Passenger.find(params[:id])
    if passengers.update params[:passenger] 
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
end
