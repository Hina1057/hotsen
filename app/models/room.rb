class Room < ApplicationRecord
    belongs_to :hotel
    has_many :reservations, dependent: :destroy
  
    enum room_type: { single: 0, double: 1, twin: 2 }, _prefix: true
  
    before_validation :set_max_person_by_room_type
  
    validates :room_type, presence: true
    validates :max_person, numericality: { only_integer: true, greater_than: 0 }
    validates :room_price, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :room_stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
    validates :room_type, uniqueness: { scope: :hotel_id }

    def label
        "#{room_type} / 定員#{max_person}名 / #{room_price}円"
    end
  
    private
  
    def set_max_person_by_room_type
      return if room_type.blank?
  
      self.max_person =
        case room_type
        when "single" then 1
        when "double" then 2
        when "twin"   then 2
        end
    end
  end