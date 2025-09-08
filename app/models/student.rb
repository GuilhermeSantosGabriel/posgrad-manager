class Student < ApplicationRecord
  def index
    @students = Students.all
end
