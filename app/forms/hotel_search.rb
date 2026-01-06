class HotelSearch
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :area, :string
  attribute :check_in_on, :date
  attribute :stay_count, :integer, default: 1
  attribute :guest_count, :integer, default: 1

  validates :area, presence: true
  validates :check_in_on, presence: true
  validates :stay_count, numericality: { only_integer: true, greater_than: 0 }
  validates :guest_count, numericality: { only_integer: true, greater_than: 0 }

  validate :check_in_not_past

  private

  def check_in_not_past
    return if check_in_on.blank?
    if check_in_on < Date.current
      errors.add(:check_in_on, "は過去の日付を指定できません")
    end
  end
end
