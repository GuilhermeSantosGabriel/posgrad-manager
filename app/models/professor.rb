class Professor < ApplicationRecord
  belongs_to :user
  has_many :students
  has_many :publications
end
