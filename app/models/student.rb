class Student < ApplicationRecord
  belongs_to :user
  has_one :professor
  has_many :reports, dependent: :destroy
  has_many :publications, dependent: :destroy

  def calculate_progress
    if credits_needed > 0
      return (100* credits/credits_needed)
    else
      return 0
    end
  end
end
