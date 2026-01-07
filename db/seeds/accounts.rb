Account.find_or_create_by!(email: "Taro@example.com") do |u|
    u.name = "Taro"
    u.password = "password"
    u.password_confirmation = "password"
    u.address = "東京都新宿区"
    u.birthday = Date.new(2000, 1, 1)
    u.sex = 0
    u.phone_number = "01-2345-6789"
end

Account.find_or_create_by!(email: "user1@example.com") do |u|
    u.name = "Jun"
    u.password = "password"
    u.password_confirmation = "password"
    u.address = "東京都新宿区"
    u.birthday = Date.new(2000, 1, 1)
    u.sex = 0
    u.phone_number = "01-2345-6789"
end
  