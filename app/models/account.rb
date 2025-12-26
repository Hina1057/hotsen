class Account < ApplicationRecord
    has_secure_password
  
    has_many :reservations, dependent: :destroy
  
    enum sex: { unknown: 0, male: 1, female: 2 }, _prefix: true
  
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :address, presence: true
    validates :birthday, presence: true
    validates :sex, presence: true
    validates :phone_number, presence: true
  end
  