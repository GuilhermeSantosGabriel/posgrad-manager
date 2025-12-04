class Student < ApplicationRecord
  belongs_to :user
  has_one :professor
  has_one :contact_info, through: :user
  has_many :publications, dependent: :destroy
  has_many :report_infos, dependent: :destroy
  has_many :reports, through: :report_infos
  has_many :report_field_answers, through: :report_infos

  before_save :update_lattes_timestamp, if: :will_save_change_to_lattes_link?

  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :contact_info
  # attr_accessible :user_attributes, :contact_info_attributes

  def full_name
    user.full_name
  end

  def professor
    if !professor_id.nil?
      Professor.find(professor_id)
    else
      nil
    end
  end

  def calculate_progress
    if user.status == 'Graduado'
      100
    elsif semester > 0
      if program_level == 'Doutorado'
        100 * semester / 8
      else
        100 * semester / 4
      end
    else
      0
    end
  end

  private

  def update_lattes_timestamp
    self.lattes_last_update = Date.today
  end
end
