puts "Loading hotels..."

image_path = Rails.root.join("db/seed_images/hotel.jpg")

# 予約も消すなら先に（必要なら）
Reservation.destroy_all
Room.destroy_all
Hotel.destroy_all

hotels = [
  {
    name: "横浜1号店",
    area: "横浜",
    address: "神奈川県横浜市中区1-1-1",
    phone_number: "045-111-1111",
    parking_capacity: 30,
    wifi: true,
    large_bath: true,
    openair_bath: true,
    sauna: true,
    bedrock_bath: false,
    barrier_free: true,
    smoking_area: false,
    information: "横浜港を一望できる展望温泉が魅力のホテルです。",
    rooms: [
      { room_type: :single, room_price: 9000, room_stock: 5 },
      { room_type: :double, room_price: 14000, room_stock: 4 },
      { room_type: :twin,   room_price: 15000, room_stock: 3 }
    ]
  },
  {
    name: "川崎シティスパホテル",
    area: "川崎",
    address: "神奈川県川崎市川崎区2-2-2",
    phone_number: "044-222-2222",
    parking_capacity: 20,
    wifi: true,
    large_bath: true,
    openair_bath: false,
    sauna: true,
    bedrock_bath: false,
    barrier_free: false,
    smoking_area: true,
    information: "ビジネスにも観光にも便利な立地のスパホテル。",
    rooms: [
      { room_type: :single, room_price: 8000, room_stock: 6 },
      { room_type: :double, room_price: 12000, room_stock: 3 }
    ]
  },
  {
    name: "小田原城下町温泉宿",
    area: "小田原",
    address: "神奈川県小田原市3-3-3",
    phone_number: "0465-33-3333",
    parking_capacity: 15,
    wifi: false,
    large_bath: true,
    openair_bath: true,
    sauna: false,
    bedrock_bath: false,
    barrier_free: false,
    smoking_area: false,
    information: "歴史ある城下町で静かに過ごせる和風温泉宿。",
    rooms: [
      { room_type: :twin, room_price: 15000, room_stock: 3 }
    ]
  },
  {
    name: "本厚木リラックスホテル",
    area: "本厚木",
    address: "神奈川県厚木市4-4-4",
    phone_number: "046-444-4444",
    parking_capacity: 25,
    wifi: true,
    large_bath: false,
    openair_bath: false,
    sauna: false,
    bedrock_bath: false,
    barrier_free: true,
    smoking_area: true,
    information: "駅近で気軽に泊まれるシンプルなホテル。",
    rooms: [
      { room_type: :single, room_price: 7000, room_stock: 8 }
    ]
  },
  {
    name: "藤沢オーシャン温泉リゾート",
    area: "藤沢",
    address: "神奈川県藤沢市5-5-5",
    phone_number: "0466-55-5555",
    parking_capacity: 40,
    wifi: true,
    large_bath: true,
    openair_bath: true,
    sauna: true,
    bedrock_bath: true,
    barrier_free: true,
    smoking_area: false,
    information: "湘南の海を感じられるリゾート型温泉ホテル。",
    rooms: [
      { room_type: :double, room_price: 18000, room_stock: 5 },
      { room_type: :twin,   room_price: 20000, room_stock: 4 }
    ]
  }
]

hotels.each do |data|
  rooms = data.delete(:rooms)
  hotel = Hotel.create!(data)

  rooms.each do |room|
    hotel.rooms.create!(room)
  end

  if File.exist?(image_path)
    hotel.images.attach(
      io: File.open(image_path),
      filename: "hotel.jpg",
      content_type: "image/jpeg"
    )
  end
end

puts "Hotels loaded."