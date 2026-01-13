class Account < ApplicationRecord
    has_secure_password
  
    has_many :reservations, dependent: :restrict_with_error
    before_validation { self.email = email.to_s.strip.downcase }
  
    enum sex: { unknown: 0, male: 1, female: 2 }
  
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    before_validation { self.email = email.to_s.strip.downcase }
    validates :address, presence: true
    validates :birthday, presence: true
    validates :sex, presence: true
    validates :phone_number, presence: true
    validate :birthday_cannot_be_in_the_future
    validates :password,
          length: { minimum: 5, maximum: 30 },
          allow_blank: true

  private

  before_validation do
    self.email = email.to_s.strip.downcase
  end

  def birthday_cannot_be_in_the_future
    return if birthday.blank?

    if birthday > Date.today
      errors.add(:birthday, "は未来の日付を指定できません")
    end
  end
end
  