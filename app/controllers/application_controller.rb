class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  layout :layout_by_resource

  rescue_from "AccessGranted::AccessDenied" do |exception|
    redirect_to root_path, alert: "Acceso negado."
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end
end
