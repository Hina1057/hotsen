class Hotel < ApplicationRecord

    before_validation :normalize_phone_number
    has_many :rooms, dependent: :destroy
    has_many :reservations, dependent: :destroy
  
    validates :name, presence: true
    validates :address, presence: true
    validates :area, presence: true
    validates :phone_number, presence: true,
    format: { with: /\A[0-9\-]+\z/, message: "は数字とハイフンのみで入力してください" },
    length: { minimum: 10, maximum: 13 }

    private

  def normalize_phone_number
    return if phone_number.blank?
    self.phone_number = phone_number.tr("０-９", "0-9").strip
  end
  
  end