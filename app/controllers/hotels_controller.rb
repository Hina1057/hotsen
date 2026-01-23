class HotelsController < ApplicationController
  def index
    @area = params[:area].to_s.strip
    @check_in_on  = params[:check_in_on].to_s
    @check_out_on = params[:check_out_on].to_s
    @guest_count  = (params[:guest_count].presence || 1).to_i
  
    @budget = params[:budget].to_s.strip
    budget_value = @budget.present? ? @budget.to_i : nil
  
    @room_type = params[:room_type].presence
  
    facility_keys = %w[wifi large_bath openair_bath sauna bedrock_bath barrier_free smoking_area]
    @facilities = facility_keys.select { |k| params[k].present? }
  
    errors = []
    errors << "エリアを選択してください" if @area.blank?
    errors << "チェックイン日を入力してください" if @check_in_on.blank?
    errors << "チェックアウト日を入力してください" if @check_out_on.blank?
    errors << "人数は1以上を入力してください" if @guest_count < 1
    errors << "予算は0以上を入力してください" if @budget.present? && budget_value < 0
  
    check_in = nil
    check_out = nil
    stay_count = nil
  
    if @check_in_on.present? && @check_out_on.present?
      begin
        check_in = Date.parse(@check_in_on)
        check_out = Date.parse(@check_out_on)
  
        errors << "チェックイン日に過去の日付は指定できません" if check_in < Date.current
        errors << "チェックアウト日はチェックイン日より後にしてください" if check_out <= check_in
  
        if check_out > check_in
          stay_count = (check_out - check_in).to_i
          errors << "宿泊数は1以上になるようにしてください" if stay_count < 1
        end
  
        limit = Date.current + 30.days
        errors << "チェックイン日は今日から30日以内を選択してください" if check_in > limit
        errors << "宿泊期間が30日以内に収まるようにしてください" if check_out > limit
      rescue ArgumentError
        errors << "日付が正しくありません"
      end
    end
  
    if errors.any?
      flash.now[:alert] = errors.join(" / ")
      @hotels = []
      @informations = Information.order(created_at: :desc).limit(5)
      render "top/index", status: :unprocessable_entity and return
    end
  
    @stay_count = stay_count
  
    scope = Hotel.joins(:rooms).where(hotels: { area: @area })
    scope = scope.where("rooms.room_price <= ?", budget_value) if budget_value
    scope = scope.where("rooms.room_stock > 0")
  
    if @room_type.present?
      rt = Room.room_types[@room_type]
      scope = scope.where(rooms: { room_type: rt }) if rt
    end
  
    @facilities.each do |key|
      scope = scope.where(hotels: { key => true })
    end
  
    @hotels = scope.distinct.order("hotels.id")
    @searched = true
  end

  def show
    @hotel = Hotel.find(params[:id])
    @rooms = @hotel.rooms.order(:id)
  end
end