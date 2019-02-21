# frozen_string_literal: true

class Devise::RegistrationController < DeviseController
    prepend_before_action :require_no_authentication, only: [:new, :create, :cancel]
    prepend_before_action :authenticate_scope!, only: [:edit, :update, :destroy]
    prepend_before_action :set_minimum_password_length, only: [:new, :edit]
  
    # GET /user/sign_up
    def new
      build_user
      yield user if block_given?
      respond_with user
    end
  
    # POST /user
    def create
      build_user(sign_up_params)
  
      user.save
      yield user if block_given?
      if user.persisted?
        if user.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(user_name, user)
          respond_with user, location: after_sign_up_path_for(user)
        else
          set_flash_message! :notice, :"signed_up_but_#{user.inactive_message}"
          expire_data_after_sign_in!
          respond_with user, location: after_inactive_sign_up_path_for(user)
        end
      else
        clean_up_passwords user
        set_minimum_password_length
        respond_with user
      end
    end
  
    # GET /user/edit
    def edit
      render :edit
    end
  
    # PUT /user
    # We need to use a copy of the user because we don't want to change
    # the current user in place.
    def update
      self.user = user_class.to_adapter.get!(send(:"current_#{user_name}").to_key)
      prev_unconfirmed_email = user.unconfirmed_email if user.respond_to?(:unconfirmed_email)
  
      user_updated = update_user(user, account_update_params)
      yield user if block_given?
      if user_updated
        set_flash_message_for_update(user, prev_unconfirmed_email)
        bypass_sign_in user, scope: user_name if sign_in_after_change_password?
  
        respond_with user, location: after_update_path_for(user)
      else
        clean_up_passwords user
        set_minimum_password_length
        respond_with user
      end
    end
  
    # DELETE /user
    def destroy
      user.destroy
      Devise.sign_out_all_scopes ? sign_out : sign_out(user_name)
      set_flash_message! :notice, :destroyed
      yield user if block_given?
      respond_with_navigational(user){ redirect_to after_sign_out_path_for(user_name) }
    end
  
    # GET /user/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    def cancel
      expire_data_after_sign_in!
      redirect_to new_registration_path(user_name)
    end
  
    protected
  
    def update_needs_confirmation?(user, previous)
      user.respond_to?(:pending_reconfirmation?) &&
        user.pending_reconfirmation? &&
        previous != user.unconfirmed_email
    end
  
    # By default we want to require a password checks on update.
    # You can overwrite this method in your own RegistrationController.
    def update_user(user, params)
      user.update_with_password(params)
    end
  
    # Build a devise user passing in the session. Useful to move
    # temporary session data to the newly created user.
    def build_user(hash = {})
      self.user = user_class.new_with_session(hash, session)
    end
  
    # Signs in a user on sign up. You can overwrite this method in your own
    # RegistrationController.
    def sign_up(user_name, user)
      sign_in(user_name, user)
    end
  
    # The path used after sign up. You need to overwrite this method
    # in your own RegistrationController.
    def after_sign_up_path_for(user)
      after_sign_in_path_for(user) if is_navigational_format?
    end
  
    # The path used after sign up for inactive accounts. You need to overwrite
    # this method in your own RegistrationController.
    def after_inactive_sign_up_path_for(user)
      scope = Devise::Mapping.find_scope!(user)
      router_name = Devise.mappings[scope].router_name
      context = router_name ? send(router_name) : self
      context.respond_to?(:root_path) ? context.root_path : "/"
    end
  
    # The default url to be used after updating a user. You need to overwrite
    # this method in your own RegistrationController.
    def after_update_path_for(user)
      sign_in_after_change_password? ? signed_in_root_path(user) : new_session_path(user_name)
    end
  
    # Authenticates the current scope and gets the current user from the session.
    def authenticate_scope!
      send(:"authenticate_#{user_name}!", force: true)
      self.user = send(:"current_#{user_name}")
    end
  
    def sign_up_params
      devise_parameter_sanitizer.sanitize(:sign_up)
    end
  
    def account_update_params
      devise_parameter_sanitizer.sanitize(:account_update)
    end
  
    def translation_scope
      'devise.registrations'
    end
  
    private
  
    def set_flash_message_for_update(user, prev_unconfirmed_email)
      return unless is_flashing_format?
  
      flash_key = if update_needs_confirmation?(user, prev_unconfirmed_email)
                    :update_needs_confirmation
                  elsif sign_in_after_change_password?
                    :updated
                  else
                    :updated_but_not_signed_in
                  end
      set_flash_message :notice, flash_key
    end
  
    def sign_in_after_change_password?
      return true if account_update_params[:password].blank?
  
      Devise.sign_in_after_change_password
    end
  end