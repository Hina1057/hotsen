hotels = [
    {
      name: "箱根ゆったり温泉",
      area: "箱根",
      address: "神奈川県足柄下郡箱根町1-1",
      phone_number: "0460-12-3456",
      wifi: true,
      large_bath: true,
      openair_bath: true,
      sauna: false,
      bedrock_bath: false,
      barrier_free: true,
      smoking_area: false,
      information: "自然に囲まれた落ち着いた温泉宿です。",
      rooms: [
        { room_type: :single, room_price: 8000, room_stock: 5 },
        { room_type: :double, room_price: 12000, room_stock: 3 }
      ]
    },
    {
      name: "熱海オーシャンホテル",
      area: "熱海",
      address: "静岡県熱海市2-2",
      phone_number: "0557-22-3333",
      wifi: true,
      large_bath: true,
      openair_bath: false,
      sauna: true,
      bedrock_bath: true,
      barrier_free: false,
      smoking_area: true,
      information: "海が見える展望風呂が自慢のホテルです。",
      rooms: [
        { room_type: :single, room_price: 9000, room_stock: 4 },
        { room_type: :double, room_price: 13000, room_stock: 4 }
      ]
    },
    {
      name: "草津湯けむり旅館",
      area: "草津",
      address: "群馬県吾妻郡草津町3-3",
      phone_number: "0279-88-1111",
      wifi: false,
      large_bath: true,
      openair_bath: true,
      sauna: true,
      bedrock_bath: false,
      barrier_free: false,
      smoking_area: false,
      information: "源泉かけ流しの湯を楽しめる老舗旅館。",
      rooms: [
        { room_type: :twin, room_price: 14000, room_stock: 6 }
      ]
    },
    {
      name: "伊香保石段温泉宿",
      area: "伊香保",
      address: "群馬県渋川市伊香保町4-4",
      phone_number: "0279-72-4444",
      wifi: true,
      large_bath: true,
      openair_bath: false,
      sauna: false,
      bedrock_bath: false,
      barrier_free: false,
      smoking_area: false,
      information: "石段街すぐそばの観光に便利な温泉宿。",
      rooms: [
        { room_type: :single, room_price: 7500, room_stock: 4 },
        { room_type: :twin,   room_price: 13000, room_stock: 3 }
      ]
    },
    {
      name: "箱根翠嵐リゾート",
      area: "箱根",
      address: "神奈川県足柄下郡箱根町5-5",
      phone_number: "0460-55-5555",
      wifi: true,
      large_bath: true,
      openair_bath: true,
      sauna: true,
      bedrock_bath: true,
      barrier_free: true,
      smoking_area: false,
      information: "全室露天風呂付きの高級リゾートホテル。",
      rooms: [
        { room_type: :double, room_price: 22000, room_stock: 5 },
        { room_type: :twin,   room_price: 26000, room_stock: 4 }
      ]
    },
    {
      name: "別府湯けむりホテル",
      area: "別府",
      address: "大分県別府市6-6",
      phone_number: "0977-66-6666",
      wifi: true,
      large_bath: true,
      openair_bath: true,
      sauna: false,
      bedrock_bath: false,
      barrier_free: true,
      smoking_area: true,
      information: "湯けむり立ち上る別府名物の温泉ホテル。",
      rooms: [
        { room_type: :single, room_price: 6800, room_stock: 6 },
        { room_type: :double, room_price: 11000, room_stock: 5 }
      ]
    },
    {
      name: "登別温泉グランド",
      area: "登別",
      address: "北海道登別市7-7",
      phone_number: "0143-77-7777",
      wifi: false,
      large_bath: true,
      openair_bath: true,
      sauna: true,
      bedrock_bath: false,
      barrier_free: false,
      smoking_area: false,
      information: "硫黄泉が名物の北海道屈指の温泉地。",
      rooms: [
        { room_type: :twin, room_price: 16000, room_stock: 6 }
      ]
    },
    {
      name: "道後レトロ旅館",
      area: "道後",
      address: "愛媛県松山市8-8",
      phone_number: "089-88-8888",
      wifi: true,
      large_bath: false,
      openair_bath: false,
      sauna: false,
      bedrock_bath: false,
      barrier_free: false,
      smoking_area: false,
      information: "道後温泉本館近くのレトロな和風旅館。",
      rooms: [
        { room_type: :single, room_price: 7200, room_stock: 3 },
        { room_type: :twin,   room_price: 12500, room_stock: 2 }
      ]
    }
  ]

hotels.each do |data|
  rooms_data = data.delete(:rooms)

  hotel = Hotel.find_or_create_by!(name: data[:name]) do |h|
    h.assign_attributes(data)
  end

  rooms_data.each do |r|
    Room.find_or_create_by!(
      hotel: hotel,
      room_type: r[:room_type]
    ) do |room|
      room.room_price = r[:room_price]
      room.room_stock = r[:room_stock]
      # max_person は before_validation で自動設定される前提
    end
  end
end