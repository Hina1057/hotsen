class TopController < ApplicationController
  def index
    @informations = Information.order(created_at: :desc).limit(5)
  end
end
