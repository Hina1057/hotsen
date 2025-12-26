class Room < ApplicationRecord
    belongs_to :hotel
    has_many :reservations, dependent: :destroy
  
    enum room_type: { single: 0, double: 1, twin: 2 }, _prefix: true
  
    validates :room_type, presence: true
    validates :max_person, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :room_price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :room_stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  end
  