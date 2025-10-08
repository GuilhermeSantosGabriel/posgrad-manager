class Student < ApplicationRecord
  belongs_to :user
  has_one :professor
  has_many :reports, dependent: :destroy
  def index
    @students = Students.all
end
