class Student < ApplicationRecord
  belongs_to :user
  has_one :professor
  has_many :reports, dependent: :destroy
  has_many :publications, dependent: :destroy
end
