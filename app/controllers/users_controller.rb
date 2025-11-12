class UsersController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.create(user_params)
    if @user.save
      redirect_to "/", notice: "User created!"
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :login_id, :user_id, :nusp, :pronouns, :status, :password, :password_confirmation)
    # # params[:user][:login_id] = params[:nusp]
    # # params[:user][:password] = params[:nusp]
    # # params[:user][:password_confirmation] = params[:nusp]
    # params.merge!(:password, params[:nusp])
    # params.merge!(:password_confirmation, params[:nusp])
    # params[:password] = "14656895"
    # params[:password_confirmation] = "14656895"
    # params[:user][:password] = params.nusp
    #params[:user][:password_confirmation] = params.nusp



    # password_params = ActionController::Parameters.new(password: params[:nusp], password_confirmation: params[:nusp])
    # permitted = password_params.permit(:password, :password_confirmation)
    # # params[:user][:password_confirmation] = params[:user][:nusp]
    # params.merge!(permitted)
  end
end
