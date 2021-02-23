# frozen_string_literal: true

class PassengerLogin
  def initialize(app)
    @app = app
  end

  def call(env)
    env['fcIdNumber'] = env['rack.session']['spire']
    env['givenName'] = env['rack.session']['first_name']
    env['surName'] = env['rack.session']['last_name']
    env['mail'] = env['rack.session']['email']
    @app.call(env)
  end
end
