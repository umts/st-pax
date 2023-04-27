# frozen_string_literal: true

class PassengerMailer < ApplicationMailer
  layout 'passenger_mailer'

  def notify_archived(passenger)
    @passenger = passenger
    mail to: @passenger.email, subject: "#{t 'department.name'} Account Archived"
  end

  def notify_active(passenger)
    @passenger = passenger
    mail to: @passenger.email, subject: "#{t 'department.name'} Account Confirmed"
  end

  def notify_pending(passenger)
    @passenger = passenger
    mail to: @passenger.email, subject: "#{t 'department.name'} Account Created"
  end
end
