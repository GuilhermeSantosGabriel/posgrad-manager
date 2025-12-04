class RemoveCredits < ActiveRecord::Migration[8.1]
  def change
    remove_column :students, :credits, :integer
    remove_column :students, :credits_needed, :integer
  end
end
