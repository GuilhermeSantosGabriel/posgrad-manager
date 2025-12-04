class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, only: %i[home update]
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
    @student = Student.find_by(params[:id])
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
    if (@student.user != current_user)
      redirect_to root_path, notice: 'Você não possui autorização para essa ação.' unless current_user.administrator?
    end
  end

  def update
    if @student.update!(student_params)
      redirect_to student_home_path, notice: 'Perfil atualizado com sucesso!'
    else
      redirect_to student_edit_path(id: @student.id)
    end
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
    params.require(:student).permit(:name, :student_id, :program_level, :lattes_link, :lattes_last_update,
                                    :pretended_career, :join_date, :semester, :professor_id)
  end

  def check_permissions
    redirect_to root_path, notice: 'Você não é um aluno.' unless current_user.student?
  end
end
