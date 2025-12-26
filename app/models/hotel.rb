class Hotel < ApplicationRecord
    has_many :rooms, dependent: :destroy
    has_many :reservations, dependent: :destroy
  
    validates :name, presence: true
    validates :address, presence: true
    validates :area, presence: true
    validates :phone_number, presence: true
  end