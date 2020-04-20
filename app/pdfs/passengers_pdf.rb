# frozen_string_literal: true

require 'prawn/table'

class PassengersPDF < Prawn::Document
<<<<<<< HEAD
  def initialize(passengers, filters)
    super(page_layout: :landscape, page_size: 'TABLOID')
=======
  def initialize(passengers, filter)
    super(page_layout: :landscape)
>>>>>>> 120c70ea487769cfc99cf44fad2948405335c167
    font_families.update(
      'DejaVu Sans' => {
        normal: Rails.root.join('app', 'assets', 'fonts', 'DejaVuSans.ttf'),
        bold: Rails.root.join('app', 'assets', 'fonts', 'DejaVuSansBold.ttf')
      }
    )
    font 'DejaVu Sans'
    header(filter)
    passengers_table(passengers)
  end

  def passengers_table(passengers)
    font_size 14
    headers = [
      'Name',
      'Needs longer rides?',
      'Mobility Device',
      'Phone',
      'Rides Expire',
      'Notes'
    ]
    passenger_table = passengers.map { |p| passenger_row p }.unshift headers
    table passenger_table, header: true, cell_style: { font: 'DejaVu Sans' } do
      row(0).font_style = :bold
    end
  end

  def passenger_row(passenger)
    name = passenger.name
    needs_longer_ride = if passenger.needs_longer_rides?
                          # unicode for checkmark
                          "\u2714"
                        else ''
                        end
    mobility_device = passenger.mobility_device.try(:name)
    phone = passenger.phone
    expiration = passenger.rides_expire
    note = passenger.note
    [name, needs_longer_ride, mobility_device, phone, expiration, note]
  end

  def header(filter)
    font_size 30
    date = Time.now.strftime('%m/%d/%Y')
    title = [filter, 'Passengers', date].compact.map(&:capitalize).join(' ')
    text title, style: :bold, size: 30
    move_down 20
  end
end
