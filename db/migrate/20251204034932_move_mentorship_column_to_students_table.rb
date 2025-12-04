class MoveMentorshipColumnToStudentsTable < ActiveRecord::Migration[8.1]
  def change
    drop_table :professor_mentors_students
    add_column :students, :professor_id, :integer
    add_foreign_key :students, :professors, column: :professor_id

  end
end
