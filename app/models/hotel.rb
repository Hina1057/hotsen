class Hotel < ApplicationRecord
    AREAS = [
        "川崎",
        "横浜",
        "小田原",
        "本厚木",
        "藤沢"
      ]


    before_validation :normalize_phone_number
    has_many :rooms, dependent: :destroy
    has_many :reservations, dependent: :destroy
    has_many_attached :images
    validate :images_type


  
    validates :name, presence: true
    validates :address, presence: true
    validates :area, presence: true
    validates :phone_number, presence: true,
    format: { with: /\A[0-9\-]+\z/, message: "は数字とハイフンのみで入力してください" },
    length: { minimum: 10, maximum: 13 }
    validates :parking_capacity,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }

    private

  def normalize_phone_number
    return if phone_number.blank?
    self.phone_number = phone_number.tr("０-９", "0-9").strip
  end

  def images_type
    images.each do |image|
      unless image.content_type.in?(%w[image/jpeg image/png])
        errors.add(:images, "はJPEGまたはPNGのみ対応しています")
      end
    end
  end

  end