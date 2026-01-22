class ReservationsController < ApplicationController
  before_action :require_login
  before_action :set_hotel, only: [:new, :confirm, :create]

  def new
    @rooms = @hotel.rooms.where("room_stock > 0").order(:id)
    @reservation = Reservation.new(
      check_in_on: params[:check_in_on],
      stay_count: (params[:stay_count].presence || 1),
      guest_count: (params[:guest_count].presence || 1)
    )
  end

  def confirm
    @rooms = @hotel.rooms.order(:id)
    @reservation = current_account.reservations.new(reservation_params)
    @reservation.hotel_id = @hotel.id
  
    @reservation.check_in_on ||= params[:check_in_on]
  
    if @reservation.room_id.blank?
      flash.now[:alert] = "部屋グレードを選択してください"
      render :new, status: :unprocessable_entity and return
    end
  
    if @reservation.check_in_on.blank?
      flash.now[:alert] = "チェックイン日を入力してください"
      render :new, status: :unprocessable_entity and return
    end
  
    if @reservation.stay_count.to_i < 1
      flash.now[:alert] = "宿泊数は1以上を入力してください"
      render :new, status: :unprocessable_entity and return
    end
  
    if @reservation.pay_method.blank?
      flash.now[:alert] = "支払い方法を選択してください"
      render :new, status: :unprocessable_entity and return
    end
  
    calculate_total_price(@reservation)
  end


  def create
    @rooms = @hotel.rooms.order(:id)
  
    begin
      @reservation = ReservationCreator.new(
        account: current_account,
        hotel: @hotel,
        params: reservation_params
      ).call
  
      redirect_to reservation_path(@reservation), notice: "予約が完了しました"
    rescue => e
      @reservation = current_account.reservations.new(reservation_params)
      @reservation.hotel_id = @hotel.id
      flash.now[:alert] = "満室につき予約できません"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @reservation = Reservation.find(params[:id])
    redirect_to root_path, alert: "権限がありません" if @reservation.account_id != current_account.id
  end

  def cancel
    reservation = Reservation.find(params[:id])
    if reservation.account_id != current_account.id
      redirect_to root_path, alert: "権限がありません"
      return
    end

    reservation.destroy
    redirect_to reservations_account_path(current_account), notice: "予約をキャンセルしました"
  end

  private

  def set_hotel
    @hotel = Hotel.find(params[:hotel_id])
  end

  def calculate_total_price(reservation)
    room = @hotel.rooms.find(reservation.room_id)
    base = room.room_price * reservation.stay_count
  
    option = 0
    option += 1000 * reservation.stay_count if reservation.breakfast
    option += 2000 * reservation.stay_count if reservation.dinner
  
    reservation.total_price = base + option
  end

  
  def reservation_params
    p = params.require(:reservation).permit(
      :room_id, :check_in_on, :stay_count, :guest_count,
      :pay_method, :breakfast, :dinner
    )
  
    p[:pay_method] = p[:pay_method].to_i if p[:pay_method].present?
  
    p
  end
end
