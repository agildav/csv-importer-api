class Api::V1::AuthController < ApplicationController
  before_action :authenticate!, except: [:login, :register]

  def logout
    render_response([AuthService::LogoutUser.call(@current_user)], nil, :no_content)
  end

  def login
    render_response([AuthService::LoginUser.call(login_params).result], AuthSerializer, :ok)
  end

  def register
    render_response([AuthService::RegisterUser.call(register_params).result], AuthSerializer, :created)
  end

  def validate_token
    render_response([@current_user], AuthSerializer, :ok)
  end

  private

  def login_params
    params.require(:user).permit(:email, :password)
  end

  def register_params
    params.require(:user).permit(
      :email,
      :password
    )
  end
end
