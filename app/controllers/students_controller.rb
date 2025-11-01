class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, only: %i[home show]

  def home
  end

  def show
  end

  def new
    @student = current_user.students.build
  end

  def create
    @student = current_user.students.new(student_params)
    if @student.save
      redirect_to @student, notice: "Student created!"
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @student.errors, status: :unprocessable_entity }
    end
  end

  private

  def set_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:name)
  end
end
