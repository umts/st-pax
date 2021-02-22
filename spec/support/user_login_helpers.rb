# frozen_string_literal: true

def when_current_user_is(user)
  current_user =
    case user
    when :anybody, :anyone then create :user
    when Symbol then create :user, user
    when User then user
    when nil then nil
    else raise ArgumentError, 'Invalid user type'
    end
  login_as current_user
end

def login_as(user)
  case user
  when User
    assign_session_values(user_id: user.id)
  when Passenger
    login_as_passenger(user)
  end
end

def login_as_passenger(passenger)
  if passenger.persisted?
    assign_session_values(passenger_id: passenger.id)
  else
    name = passenger.name.split
    assign_session_values(spire: passenger.spire,
                          first_name: name.first,
                          last_name: name.last,
                          email: passenger.email)
  end
end

def assign_session_values(**session_values)
  case self.class.metadata[:type]
  when :system
    page.set_rack_session(session_values)
  when :controller
    session.merge!(session_values)
  end
end
