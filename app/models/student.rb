class Student < ApplicationRecord
  belongs_to :user
  has_one :professor
  has_many :publications, dependent: :destroy
  has_many :report_infos
  has_many :report_field_answers, through: :report_info

  def calculate_progress
    if credits_needed > 0
      return (100* credits/credits_needed)
    else
      return 0
    end
  end
end
