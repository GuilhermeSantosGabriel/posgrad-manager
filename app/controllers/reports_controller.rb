class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_report, only: %i[ show edit update ]
  before_action :check_permissions, only: %i[ create ]

  def show
  end

  def edit
  end

  def update
    if @report.update(report_params)
      redirect_to report_home_path, notice: "Report was successfully updated!"
    else
      render :edit
    end
  end

  def new
    @report = report.new
  end

  def create
    @report = current_user.build_report(report_params)
    if @report.save
      redirect_to root_path, notice: "report created!"
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @report.errors, status: :unprocessable_entity }
    end
  end

  private

  def set_report
    @report = Report.find_by(params[:id])
  end

  # TODO: edit these + add other report controllers
  def report_params
    params.require(:report).permit(:name, :report_id, :professor_comments, :coordinator_comments, :reviewer, :review_date, :status, :student_id )
  end

  def check_permissions
    if !Student.where(user_id: current_user.id).exists?
      redirect_to root_path, notice: "You're not a student."
    end
  end
end
