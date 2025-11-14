class Report < ApplicationRecord
  has_many :report_infos
  has_many :report_fields  
end
