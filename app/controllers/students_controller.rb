class StudentsController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]
  before_action :set_student, only: %i[ show edit update destroy ]

  def index
    @students = Student.all
  end

  def show
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      redirect_to @student
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end
  
  def update
    if @student.update(student_params)
      redirect_to @student
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @student.destroy
    redirect_to students_path
  end

  private
    def set_student
      @student = Student.find(params[:id])
    end

    def student_params
      params.expect(student: [ :name, :nusp, :email, :password, :profile_picture])
    end

end
