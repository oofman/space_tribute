class SessionsController < ApplicationController
  skip_before_action :authenticate
  skip_before_action :verify_authenticity_token, only: [:create]

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user.try(:authenticate, params[:password])
      session[:user_id] = user.id

      respond_to do |format|
        format.html {
          redirect_to dashboard_url, :notice => "Logged in!"
        }
        format.json {
          _user = user.attributes
          _user.delete('password_digest')
          render json: {:user => _user, :token => user.token}
        }
      end
    else
      respond_to do |format|
        format.html {
          flash.now.alert = "Invalid email or password"
          render "new"
        }
        format.json {
          render json: {:error => 'you are not authorise to access this.'}
        }
      end

    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end
