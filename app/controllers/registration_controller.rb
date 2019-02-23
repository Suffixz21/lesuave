class Devise::RegistrationController < DeviseController
    # extend Devise::Models
    before_filter :configure_permitted_parameters, :only => [:create]

    def new
    end
    def edit
    end
    def update
    end
    def delete
    end
    protected
        def configure_permitted_parameters
            devise_parameter_sanitizer.permit(:sign_up) { |usr|
                usr.permit(:email,
                    :password,
                    :role)
            }
        end

    private
        def user_params
            params.require(:user).permit(:email, :password)
        end
end
