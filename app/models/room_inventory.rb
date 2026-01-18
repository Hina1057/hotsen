class RoomInventory < ApplicationRecord
  belongs_to :room

  validates :date, presence: true
  validates :available_count,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :date, uniqueness: { scope: :room_id }

  validate :not_exceed_room_stock

  private

  def not_exceed_room_stock
    return if room.nil? || available_count.nil?
    if available_count > room.room_stock
      errors.add(:available_count, "は部屋総数（#{room.room_stock}）を超えられません")
    end
  end
end