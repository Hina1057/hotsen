puts "== Seeding start =="

Dir[Rails.root.join("db/seeds/*.rb")].sort.each do |file|
  puts "Loading #{File.basename(file)}"
  load file
end

puts "== Seeding end =="
