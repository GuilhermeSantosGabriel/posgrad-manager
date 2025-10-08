class User < ApplicationRecord
  has_one :Administrator
  has_one :Student
  has_one :professor
end
