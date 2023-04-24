# frozen_string_literal: true

class PassengerMailer < ApplicationMailer
  def notify_archived(passenger)
    @passenger = passenger
    mail to: @passenger.email, subject: 'Accessible Van Service Account Archived'
  end

  def notify_active(passenger)
    @passenger = passenger
    mail to: @passenger.email, subject: 'Accessible Van Service Account Confirmed'
  end

  def notify_pending(passenger)
    @passenger = passenger
    mail to: @passenger.email, subject: 'Accessible Van Service Account Created'
  end
end
