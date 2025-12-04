class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
    redirect_to root_path
  end

  def contact_info
    @user = User.find(params[:user_id])
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'Usuário atualizado com sucesso!', data: { turbo: false }
    else
      redirect_to root_path, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(
      :name, :surname, :email, :login_id, :nusp, :pronoun, :status, :first_login,
      student_attributes: %i[id name program_level lattes_link lattes_last_update pretended_career join_date semester professor_id],
      professor_attributes: %i[id research_area department],
      contact_info_attributes: %i[id phone_number room_number]
    )
  end
end
