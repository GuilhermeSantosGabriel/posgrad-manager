class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, only: %i[home edit update]
  before_action :check_permissions, only: %i[home edit]
  before_action :set_professor, only: %i[home]
  before_action :list_professors, only: %i[home]

  def navigation
    respond_to do |format|
      format.html
      format.turbo_stream do
        render partial: "students/tabs/#{params[:tab] || 'report'}",
               locals: { student: @student }
      end
    end
  end

  def home
    @reports = @student.reports.order(year: :asc, semester: :asc)

    @pending_report_info = @student.report_infos
                                   .where(status: 'Draft')
                                   .order(created_at: :asc)
                                   .last

    @pending_report = @pending_report_info&.report

    return unless @pending_report_info && @pending_report

    @pending_report.report_fields.each do |field|
      @pending_report_info.report_field_answers.find_or_initialize_by(report_field_id: field.id)
    end
  end

  def show
    @student = Student.find(params[:id])
  end

  def send_report
    @send = ReportInfo.find(params[:id])
    if @send.update!(owner: 'Professor', date_sent: Date.current, status: 'Sent')
      redirect_to student_home_path, notice: 'Relatório enviado!'
    else
      redirect_to student_home_path, notice: 'Ocorreu algum erro e o relatório não pode ser enviado.'
    end
  end

  def edit
    @student = Student.find(params[:id])
    @user = @student.user
  end

  def update
    @user = @student.user

    ActiveRecord::Base.transaction do
      @student.update!(student_params)

      user_updates = { pronoun: params[:student][:pronoun] }

      if params[:password].present?
        user_updates[:password] = params[:password]
        user_updates[:password_confirmation] = params[:password_confirmation]
      end

      @user.update!(user_updates)
    end

    redirect_to edit_student_path(@student), notice: 'Perfil atualizado com sucesso!'
  rescue ActiveRecord::RecordInvalid
    flash.now[:alert] = 'Não foi possível salvar. Verifique os dados.'
    render :edit, status: :unprocessable_entity
  end

  private

  def set_student
    @student = current_user.student
  end

  def set_professor
    @professor = Professor.find_by(id: @student.professor_id)
  end

  def list_professors
    @professors = Professor.all.order(:name)
  end

  def student_params
    params.require(:student).permit(:lattes_link, :pretended_career)
  end

  def check_permissions
    redirect_to root_path, notice: 'Você não é um aluno.' unless current_user.student?
  end
end
