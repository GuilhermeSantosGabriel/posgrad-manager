class AddEntryDateToStudents < ActiveRecord::Migration[8.0]
  def change
    add_column :students, :date, :date
  end
end
