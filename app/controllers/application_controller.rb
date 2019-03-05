class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate

  private

  def current_user

    if request.headers['Auth-Token'].present? || request.parameters['auth'].present?

      encoded_token = (request.headers['Auth-Token'].present?) ? request.headers['Auth-Token'].split(' ').last : request.parameters['auth'].split(' ').last
      decoded_token = UserAuth::Token.decode(encoded_token)
      return nil if decoded_token.expired?
      @current_user = User.find(decoded_token[:id]) rescue nil

    else
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]

    end

    return @current_user
  end

  helper_method :current_user

  def authenticate
    respond_to do |format|
      format.html {
        redirect_to(login_path) unless current_user
      }
      format.json {
        render json: {:error => 'you are not authorise to access this.'} unless current_user
      }
    end

  end

end
