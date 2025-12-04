class Professor < ApplicationRecord
  belongs_to :user
  has_many :students
  has_many :publications
  has_one :contact_info, through: :user

  accepts_nested_attributes_for :user
  # V por algum motivo n ta aparecendo no forms V
  accepts_nested_attributes_for :contact_info

  def full_name
    user.full_name
  end
end
