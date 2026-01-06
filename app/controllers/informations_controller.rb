class InformationsController < ApplicationController
  def index
    @informations = Information.order(created_at: :desc)
  end

  def show
    @information = Information.find(params[:id])
  end
end
