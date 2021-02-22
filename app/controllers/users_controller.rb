class UsersController < ApplicationController

  def create
    user = User.new(user_params)

    if user.save
      log_in user

      render json: {
        status: 201,
        user:   user
      }

    else 
      render json: {
        status: 500,
        errors: ['Unable to create user.']
      }
    end
  end

	def show
    user = User.find(params[:id])

   	if user
      render json: {
        status: 200,
        user:   user
      }

    else
      render json: {
        status: 500,
        errors: ['User not found.']
      }
    end
  end

	private
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
