class Admin::ReservationsController < Admin::ApplicationController
  before_action :require_admin_login

  def index
    @reservations = Reservation.includes(:account, :hotel, :room).order(created_at: :desc)
  end

  def show
    @reservation = Reservation.includes(:account, :hotel, :room).find(params[:id])
  end
end
