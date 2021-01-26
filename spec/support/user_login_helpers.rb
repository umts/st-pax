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
  if user.is_a? User
    set_session_values(user_id: user.id)
  elsif user.is_a? Passenger
    if user.persisted?
      set_session_values(passenger_id: user.id)
    else
      name = user.name.split(' ')
      set_session_values(spire: user.spire,
                         first_name: name.first,
                         last_name: name.last,
                         email: user.email)
    end
  end
end

def set_session_values(**session_values)
  case self.class.metadata[:type]
  when :system
    page.set_rack_session(session_values)
  when :controller
    session.merge!(session_values)
  end
end
