class RemoveDateFromStudents < ActiveRecord::Migration[8.0]
  def change
    remove_column :students, :date, :date
  end
end
