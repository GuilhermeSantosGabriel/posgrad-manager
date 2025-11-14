class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Stackoverflow falou pra ter isso mas vai ficar comentado enquanto é só magia negra
  # attr_accessible :password, :password_confirmation

  has_one :administrator
  has_one :student
  has_one :professor
end
