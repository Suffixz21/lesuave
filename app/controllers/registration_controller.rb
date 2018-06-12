class RegistrationController < Devise.RegistrationController
    before_filter :configure_permitted_parameters, :only => [:create]

    protected
        def configure_permitted_parameters
            devise_parameter_sanitizer.permit(:sign_up) { |usr|
                usr.permit(:email,
                    :password,
                    :role)
            }
        end
end
