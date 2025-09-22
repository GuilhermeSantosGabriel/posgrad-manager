class AddColumnsToStudents < ActiveRecord::Migration[8.0]
  def change
    add_column :students, :nusp, :string
    add_column :students, :email, :string
    add_column :students, :password_digest, :string
    add_column :students, :pronouns, :string
    add_column :students, :number_semesters, :integer
    add_column :students, :number_failures, :integer
  end
end
