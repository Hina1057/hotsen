class Reservation < ApplicationRecord
    belongs_to :account
    belongs_to :hotel
    belongs_to :room
  
    enum pay_method: { local: 0, credit: 1 }, _prefix: true
  
    validates :check_in_on, presence: true
    validates :stay_count, presence: true,
              numericality: { only_integer: true, greater_than: 0 }
    validates :guest_count, presence: true,
              numericality: { only_integer: true, greater_than: 0 }
    validates :total_price, presence: true,
              numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
    validate :guest_count_within_capacity
    validate :room_stock_available, on: :create
  
    after_create  :decrease_stock
    before_destroy :restore_stock
  
    private
  
    def room_stock_available
      return if room.nil?
      if room.room_stock <= 0
        errors.add(:room_id, "は満室です")
      end
    end
  
    def decrease_stock
      room.decrement!(:room_stock)
    end
  
    def restore_stock
      room.increment!(:room_stock)
    end
  
    def guest_count_within_capacity
      return if room.nil? || guest_count.nil?
      if guest_count > room.max_person
        errors.add(:guest_count, "が部屋の定員を超えています")
      end
    end
  end