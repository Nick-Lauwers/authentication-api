class PasswordResetsController < ApplicationController

  def forgot
    user = User.find_by(email: params[:email].downcase)
    
    if user
      user.create_reset_digest
      user.send_password_reset_email

      render json: {
	      status: 201,
	      user:   user
	    }
    
    else
    	render json: {
	      status: 500,
	      errors: ['User not found.']
	    }
    end
  end

  def reset
    user = User.find_by(email: user_params[:email])
    
    if user &&
       user.authenticated?(user_params[:token]) &&
       !user.password_reset_expired?

      if user.reset_password(user_params[:password])
        render json: {
          status: 201,
          user: user
        }

      else
        render json: { 
          status: 422,
          errorS: ['Unable to reset password.'] 
        }
      end
    
    else
      render json: {
        status: 500,
        error:  ['Link expired. Try generating a new link.']
      }
    end
  end

  private
  
  def user_params
    params.require(:user).permit(:email, 
                                 :password, 
                                 :password_authentication, 
                                 :token)
  end
end