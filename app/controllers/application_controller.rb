class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

    def after_sign_in_path_for(resource)
      homes_top_path
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end

    def ensure_correct_user
      redirect_to root_path unless params[:user_id].to_i == current_user.id
    end
end