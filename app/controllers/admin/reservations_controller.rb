class Admin::ReservationsController < Admin::ApplicationController
  before_action :require_admin_login

  def index
    @reservations = Reservation.includes(:account, :hotel, :room).order(created_at: :desc)
  end

  def show
    @reservation = Reservation.includes(:account, :hotel, :room).find(params[:id])
  end

  def destroy
    reservation = Reservation.find(params[:id])
    room = reservation.room
    reservation.destroy
    room.increment!(:room_stock)
    redirect_to admin_reservations_path, notice: "予約を削除しました"
  end
end
