Admin.find_or_create_by!(name: "user1") do |a|
  a.password = "hotsen!"
  a.password_confirmation = "hotsen!"
end
