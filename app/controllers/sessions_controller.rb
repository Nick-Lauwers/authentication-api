class SessionsController < ApplicationController

	def create
    user = User.find_by(email: session_params[:email].downcase)
  
    if user && user.authenticate(session_params[:password])
      log_in user

      render json: {
      	status:       201,
        user:         user,
        is_logged_in: true
      }

    else
      render json: { 
        status: 401,
        errors: ['Verify credentials and try again.']
      }
    end
  end

  def destroy
    reset_session
    
    render json: {
      status: 200,
      is_logged_out: true
    }
  end

  def is_logged_in?
    if logged_in?
      render json: {
        status:       200,
        is_logged_in: true,
        user:         current_user
      }

    else
      render json: {
        status:       200,
        is_logged_in: false
      }
    end
  end

  private
  
  def session_params
    params.require(:user).permit(:email, :password)
  end
end