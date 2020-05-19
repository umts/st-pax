class PassengerMailer < ApplicationMailer
  def notify_archived(passenger)
    @passenger = passenger
    mail to: @passenger.email, subject: 'ST Account Archived'
  end
end
