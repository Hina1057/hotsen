class Information < ApplicationRecord
    self.table_name = "informations"
    validates :title, presence: true
    validates :body, presence: true
  end
  