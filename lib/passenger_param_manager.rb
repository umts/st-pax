# frozen_string_literal: true

class PassengerParamManager
  def initialize(params, env, current_user)
    @params = params
    @env = env
    @current_user = current_user
  end

  def params
    @params.then { |p| permit(p) }
           .then { |p| admin_filter(p) }
           .then { |p| user_filter(p) }
           .then { |p| include_env_values(p) }
  end

  private

  def admin_filter(parameters)
    parameters.delete_if do |key, _|
      key == 'permanent' && !@current_user&.admin?
    end
  end

  def include_env_values(parameters)
    return parameters if @current_user.present?

    spire, given_name, surname = @env.values_at('fcIdNumber', 'givenName', 'surName')
    parameters.reverse_merge(spire: spire, name: "#{given_name} #{surname}")
  end

  def permit(parameters)
    pax_params = %i[name address email phone active_status mobility_device_id
                    permanent note spire has_brocure subscribed_to_sms
                    carrier_id]
    ev_params = %i[expiration_date verifying_agency_id name address phone]

    parameters.require(:passenger)
              .permit(*pax_params, eligibility_verification_attributes: ev_params)
  end

  def user_filter(parameters)
    parameters.delete_if do |key, _|
      %w[spire name].include?(key) && @current_user.blank?
    end
  end
end
