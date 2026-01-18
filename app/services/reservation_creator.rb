class ReservationCreator
    def initialize(account:, hotel:, params:)
      @account = account
      @hotel = hotel
      @params = params
    end
  
    def call
      reservation = @account.reservations.new(@params)
      reservation.hotel = @hotel
      reservation.room  = @hotel.rooms.find(reservation.room_id)
  
      Reservation.transaction do
        ensure_inventories!(reservation)
        ensure_available!(reservation)
        decrement!(reservation)
      
        reservation.total_price = calculate_total(reservation)
        reservation.save!
      end
  
      reservation
    end
  
    private
  
    def ensure_inventories!(reservation)
        Rails.logger.debug "ENSURE room_id=#{reservation.room_id} dates=#{reservation.stay_dates.inspect}"
        Rails.logger.debug "ENSURE inventories room_id=#{reservation.room_id} dates=#{reservation.stay_dates.inspect}"
      reservation.stay_dates.each do |d|
        RoomInventory.lock.find_or_create_by!(room_id: reservation.room_id, date: d) do |inv|
          inv.available_count = reservation.room.room_stock
        end
      end
    end
  
    def ensure_available!(reservation)
      reservation.stay_dates.each do |d|
        inv = RoomInventory.find_by!(room_id: reservation.room_id, date: d)
        raise ActiveRecord::Rollback, "満室" if inv.available_count <= 0
      end
    end
  
    def decrement!(reservation)
      reservation.stay_dates.each do |d|
        inv = RoomInventory.lock.find_by!(room_id: reservation.room_id, date: d)
        inv.update!(available_count: inv.available_count - 1)
      end
    end
  
    def calculate_total(reservation)
      base = reservation.room.room_price * reservation.stay_count
      opt = 0
      opt += 1000 * reservation.stay_count if reservation.breakfast
      opt += 2000 * reservation.stay_count if reservation.dinner
      base + opt
    end
  end