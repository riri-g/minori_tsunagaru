class ApplicationController < ActionController::Base
    before_action :authenticate_user!,except: [:top] 
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :update_last_sign_in_at

    protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end

    def after_sign_in_path_for(resource)
        posts_path
    end

    private

  def update_last_sign_in_at
    if current_user && current_user.last_sign_in_at.nil?
      current_user.update(last_sign_in_at: Time.current)
    end
  end

end

