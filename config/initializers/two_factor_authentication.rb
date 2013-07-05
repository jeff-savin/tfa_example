class Devise::TwoFactorAuthenticationController < ActiveAdmin::Devise::SessionsController# < ActiveAdmin::Devise::Controller # < DeviseController
  prepend_before_filter :authenticate_scope!
  before_filter :prepare_and_validate, :handle_two_factor_authentication

  def show
  end

  def update
    render :show and return if params[:code].nil?
    md5 = Digest::MD5.hexdigest(params[:code])
    if md5.eql?(resource.second_factor_pass_code)
      warden.session(resource_name)[:need_two_factor_authentication] = false
      sign_in resource_name, resource, :bypass => true
      redirect_to stored_location_for(resource_name) || '/admin' # || :root
      resource.update_attribute(:second_factor_attempts_count, 0)
    else
      resource.second_factor_attempts_count += 1
      resource.save
      set_flash_message :notice, :attempt_failed
      if resource.max_login_attempts?
        sign_out(resource)
        render :template => 'devise/two_factor_authentication/max_login_attempts_reached' and return
      else
        render :show
      end
    end
  end

  private

    def authenticate_scope!
      self.resource = send("current_#{resource_name}")
    end

    def prepare_and_validate
      redirect_to :root and return if resource.nil?
      @limit = resource.class.max_login_attempts
      if resource.max_login_attempts?
        sign_out(resource)
        render :template => 'devise/two_factor_authentication/max_login_attempts_reached' and return
      end
    end
end

module TwoFactorAuthentication
  module Controllers
    module Helpers
      extend ActiveSupport::Concern

      included do
        before_filter :handle_two_factor_authentication
      end

      private

      def handle_two_factor_authentication
        if not request.format.nil? and request.format.html? and not devise_controller?
          scope = 'admin_user'
          # ActiveAdmin::Devise.mappings.keys.flatten.any? do |scope|
            if signed_in?(scope) and warden.session(scope)[:need_two_factor_authentication]
              session["#{scope}_return_tor"] = request.path if request.get?
              redirect_to two_factor_authentication_path_for(scope)
              return
            end
          # end
        end
      end

      def two_factor_authentication_path_for(resource_or_scope = nil)
        # scope = ActiveAdmin::Devise::Mapping.find_scope!(resource_or_scope)
        scope = 'admin_user'
        change_path = "#{scope}_two_factor_authentication_path"
        send(change_path)
      end

    end
  end
end