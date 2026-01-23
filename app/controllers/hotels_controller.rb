class HotelsController < ApplicationController
  def index
    @area = params[:area].to_s.strip
    @check_in_on = params[:check_in_on].to_s
    @stay_count = (params[:stay_count].presence || 1).to_i
    @guest_count = (params[:guest_count].presence || 1).to_i

    @room_type = params[:room_type].presence
    

    @budget = params[:budget].to_s.strip
    budget_value = @budget.present? ? @budget.to_i : nil

    facility_keys = %w[wifi large_bath openair_bath sauna bedrock_bath barrier_free smoking_area]
    @facilities = facility_keys.select { |k| params[k].present? }

    errors = []
    errors << "エリアを選択してください" if @area.blank?
    errors << "チェックイン日を入力してください" if @check_in_on.blank?

    limit = Date.current + 30.days

    if @check_in_on.present?
      begin
        check_in = Date.parse(@check_in_on)

        errors << "チェックイン日は今日から30日以内を選択してください" if check_in > limit

        check_out = check_in + (@stay_count - 1)
        errors << "宿泊期間が30日以内に収まるようにしてください" if check_out > limit
      rescue ArgumentError
        errors << "チェックイン日が正しくありません"
      end
    end

    errors << "宿泊数は1以上を入力してください" if @stay_count < 1
    errors << "人数は1以上を入力してください" if @guest_count < 1
    errors << "予算は0以上を入力してください" if @budget.present? && budget_value < 0

    if errors.any?
      flash.now[:alert] = errors.join(" / ")
      @hotels = []
      @informations = Information.order(created_at: :desc).limit(5)
      render "top/index", status: :unprocessable_entity and return
    end

    # 検索：hotels × rooms
scope = Hotel.joins(:rooms)

# エリア
scope = scope.where(hotels: { area: @area })

# 部屋タイプ（指定があるときだけ）
if @room_type.present?
  rt = Room.room_types[@room_type]  # "single"->0 など
  scope = scope.where(rooms: { room_type: rt }) if rt
end

# 予算（1泊あたり上限）
scope = scope.where("rooms.room_price <= ?", budget_value) if budget_value

# 在庫あり（今の方式なら）
scope = scope.where("rooms.room_stock > 0")

# 設備（AND）
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