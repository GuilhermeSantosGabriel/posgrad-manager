class ReportsController < ApplicationController
  require 'prawn'
  before_action :authenticate_user!
  before_action :set_report, only: %i[show edit update destroy]
  before_action :check_permissions, only: %i[new create]

  def show
    @report = Report.find(params[:id])

    @reports_pending = @report.report_infos.where(status: 'Draft')

    @reports_to_review = @report.report_infos.where(status: 'Sent')

    @reports_in_progress = @report.report_infos.where(status: 'Reviewed')

    @reports_done = @report.report_infos.where(status: 'Archived')
  end

  def index
    @reports = Report.order(year: :desc, semester: :desc)
  end

  def options
    @reports = Report.order(year: :desc, semester: :desc)
  end

  def new
    @report = Report.new
    @report.report_fields.build
  end

  def create
    @report = Report.new(report_params)

    if params[:commit] == 'Adicionar questão'
      @report.report_fields.build
      return render :new
    end

    if @report.save
      Student.find_each do |student|
        ReportInfo.create!(student: student, report: @report)
      end
      redirect_to adm_home_path, notice: 'Relatório criado com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @report.report_fields.build if @report.report_fields.empty?
  end

  def update
    if @report.update(report_params)
      redirect_to adm_home_path, notice: 'Relatório atualizado!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy
    redirect_to adm_home_path, notice: 'Relatório removido!'
  end

  def export_pdf
    @report_info = ReportInfo.find(params[:id])
    @report = @report_info.report
    @answers = @report_info.report_field_answers.includes(:report_field)
    @student = @report_info.student

    pdf = Prawn::Document.new(page_size: 'A4', margin: 30)

    pdf.fill_color '2762ff'
    pdf.text "Relatório: #{@report.semester}º Semestre de #{@report.year}", size: 14, style: :bold, align: :center
    pdf.text "Programa: #{@student.program_level}", size: 14, style: :bold, align: :center
    pdf.text "Aluno: #{@student.user&.full_name}", size: 14, style: :bold, align: :center
    pdf.move_down 20
    pdf.text "Professor orientador: #{@student.professor&.user&.full_name}", size: 14, align: :right
    pdf.text "Email do aluno: #{@student.user&.email}", size: 14, align: :right
    pdf.text "Gerado em: #{Time.current.strftime('%d/%m/%Y às %I:%M %p')}", size: 14, align: :right

    pdf.move_down 40
    pdf.fill_color '9212ff'
    pdf.text 'Respostas:', size: 16, style: :bold

    pdf.stroke_horizontal_rule

    @answers.each do |ans|
      pdf.fill_color '9212ff'
      pdf.text ans.report_field.question, size: 12
      pdf.fill_color '2762ff'
      pdf.text ans.answer.presence, size: 11
      pdf.text ans.report_field.required.to_s, size: 11
      pdf.move_down 20
      pdf.stroke_horizontal_rule
    end

    file_name = "#{@student.user.full_name.parameterize}_#{@report.semester}_#{@report.year}.pdf"
    send_data pdf.render,
              filename: file_name,
              type: 'application/pdf',
              template: 'reports/export_pdf',
              formats: %i[html pdf],
              layout: false,
              page_size: 'A4',
              margin: { top: 10, bottom: 10, left: 10, right: 10 },
              disposition: 'attachment'
  end

  # def export_pdf
  #   @report_info = ReportInfo.find(params[:id])
  #   @report = @report_info.report
  #   @answers = @report_info.report_field_answers.includes(:report_field)
  #   @student = @report_info.student

  #   respond_to do |format|
  #     format.html
  #     format.pdf do
  #       render pdf: 'relatorio_semestral',
  #              template: 'reports/export_pdf',
  #              formats: %i[html pdf],
  #              layout: false,
  #              page_size: 'A4',
  #              margin: { top: 10, bottom: 10, left: 10, right: 10 },
  #              disposition: 'attachment'
  #     end
  #   end
  # end

  private

  def set_report
    @report = Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(
      :semester,
      :year,
      :due_date_student,
      :due_date_professor,
      :due_date_administrator,
      report_fields_attributes: %i[
        id question field_type required options _destroy
      ]
    )
  end

  def check_permissions
    return if current_user.administrator?

    redirect_to root_path, alert: 'Apenas administradores podem criar relatórios.'
  end
end
