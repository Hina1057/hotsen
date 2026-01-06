class TopController < ApplicationController
  def index
    @informations = Information.order(created_at: :desc).limit(5)
    @search = HotelSearch.new
  end
end
